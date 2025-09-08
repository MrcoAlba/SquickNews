import Foundation
import Testing
@testable import SquickNews

struct GetHeadlinesRepositoryTests {

    // MARK: - Test Doubles

    final class RemoteMock: GetHeadlinesRemoteDataSourceType {
        enum Mode { case success(HeadlineResponseDTO), failure(HTTPClientError) }
        var mode: Mode
        init(_ mode: Mode) { self.mode = mode }

        private(set) var received: (page: Int, pageSize: Int)?
        func fetchHeadlines(page: Int, pageSize: Int) async throws(HTTPClientError) -> HeadlineResponseDTO {
            received = (page, pageSize)
            switch mode {
            case .success(let dto): return dto
            case .failure(let err): throw err
            }
        }
    }

    final class ErrorMapperStub: HeadlinesDomainErrorMapper {
        override func map(error: HTTPClientError?) -> DomainError {
            switch error {
            case .tooManyRequests: return .tooManyRequests
            case .clientError:     return .invalidParameters
            case .serverError:     return .server
            case .generic:         return .network
            default:               return .generic
            }
        }
    }

    @Test func success_maps_dto_to_entity() async throws {
        // Given
        let now = ISO8601DateFormatter().string(from: Date())
        let dto = HeadlineResponseDTO(
            status: "ok",
            totalResults: 1,
            articles: [
                HeadlineItemDTO(
                    title: "Title",
                    description: "Desc",
                    url: "https://example.com",
                    urlToImage: "https://picsum.photos/200",
                    publishedAt: now,
                    source: SourceDTO(id: "src", name: "SRC")
                )
            ]
        )
        let remote = RemoteMock(.success(dto))
        let sut = GetHeadlinesRepository(
            remoteDataSource: remote,
            domainMapper: HeadlinesDomainMapper(),
            errorMapper: ErrorMapperStub()
        )

        // When
        let out = try await sut.getHeadlines(page: 3, pageSize: 10)

        // Then
        #expect(remote.received?.page == 3)
        #expect(remote.received?.pageSize == 10)
        #expect(out.status == "ok")
        #expect(out.totalResults == 1)
        #expect(out.articles.first?.title == "Title")
        #expect(out.articles.first?.source == "SRC")
    }

    @Test func failure_maps_http_error_to_domain_error() async {
        // Given
        let remote = RemoteMock(.failure(.tooManyRequests))
        let sut = GetHeadlinesRepository(
            remoteDataSource: remote,
            domainMapper: HeadlinesDomainMapper(),
            errorMapper: ErrorMapperStub()
        )

        // When / Then
        await #expect(throws: DomainError.tooManyRequests) {
            _ = try await sut.getHeadlines(page: 1, pageSize: 10)
        }
    }
}
