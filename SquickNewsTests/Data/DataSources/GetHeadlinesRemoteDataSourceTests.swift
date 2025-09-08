import Foundation
import Testing
@testable import SquickNews

struct GetHeadlinesRemoteDataSourceTests {

    // MARK: - Test Doubles

    final class HTTPClientMock: HTTPClient {
        enum Mode { case success(Data), failure(HTTPClientError) }
        var mode: Mode
        init(_ mode: Mode) { self.mode = mode }

        private(set) var lastEndpoint: Endpoint?
        private(set) var lastBaseURL: String?

        func makeRequest(endPoint: Endpoint, baseURL: String) async throws(HTTPClientError) -> Data {
            lastEndpoint = endPoint
            lastBaseURL = baseURL
            switch mode {
            case .success(let data): return data
            case .failure(let err): throw err
            }
        }
    }

    final class DecoderMock: JSONDecoderWrapper {
        let out: HeadlineResponseDTO
        init(out: HeadlineResponseDTO) { self.out = out }
        override func decode<T>(_ type: T.Type, from data: Data) throws(HTTPClientError) -> T where T : Decodable {
            return out as! T
        }
    }

    func sampleDTO() -> HeadlineResponseDTO {
        HeadlineResponseDTO(
            status: "ok",
            totalResults: 2,
            articles: [
                HeadlineItemDTO(
                    title: "A",
                    description: "a-desc",
                    url: "https://example.com/a",
                    urlToImage: "https://picsum.photos/id/1/200",
                    publishedAt: "2024-09-01T12:00:00Z",
                    source: SourceDTO(id: "s1", name: "SRC1")
                ),
                HeadlineItemDTO(
                    title: "B",
                    description: "b-desc",
                    url: "https://example.com/b",
                    urlToImage: nil,
                    publishedAt: "2024-09-02T08:00:00Z",
                    source: SourceDTO(id: "s2", name: "SRC2")
                )
            ]
        )
    }

    @Test func builds_correct_request_and_decodes() async throws {
        // Given
        let apiKey = "TEST_KEY_123"
        let http = HTTPClientMock(.success(Data("{}".utf8)))
        let decoder = DecoderMock(out: sampleDTO())
        let sut = GetHeadlinesRemoteDataSource(httpClient: http, decoder: decoder, apiKey: apiKey)

        // When
        let dto = try await sut.fetchHeadlines(page: 3, pageSize: 50)

        // Then
        #expect(http.lastBaseURL == "https://newsapi.org/v2/")
        #expect(http.lastEndpoint?.path == "top-headlines")

        let qp = http.lastEndpoint?.queryParameters ?? [:]
        #expect(qp["country"] as? String == "us")
        #expect(qp["page"] as? String == "3")
        #expect(qp["pageSize"] as? String == "50")
        #expect(qp["apiKey"] as? String == apiKey)

        #expect(dto.status == "ok")
        #expect(dto.totalResults == 2)
        #expect(dto.articles.count == 2)
        #expect(dto.articles.first?.source?.name == "SRC1")
    }

    @Test func propagates_http_errors_from_client() async {
        // Given
        let http = HTTPClientMock(.failure(.tooManyRequests))
        let decoder = DecoderMock(out: sampleDTO())
        let sut = GetHeadlinesRemoteDataSource(httpClient: http, decoder: decoder, apiKey: "x")

        // When / Then
        await #expect(throws: HTTPClientError.tooManyRequests) {
            _ = try await sut.fetchHeadlines(page: 1, pageSize: 10)
        }
    }

    @Test func bubbles_parsing_error_from_decoder() async {
        // Given
        final class FailingDecoder: JSONDecoderWrapper {
            override func decode<T>(_ type: T.Type, from data: Data) throws(HTTPClientError) -> T where T : Decodable {
                throw .parsingError
            }
        }
        let http = HTTPClientMock(.success(Data("{\"status\":\"ok\"}".utf8)))
        let decoder = FailingDecoder()
        let sut = GetHeadlinesRemoteDataSource(httpClient: http, decoder: decoder, apiKey: "x")

        // When / Then
        await #expect(throws: HTTPClientError.parsingError) {
            _ = try await sut.fetchHeadlines(page: 1, pageSize: 20)
        }
    }
}
