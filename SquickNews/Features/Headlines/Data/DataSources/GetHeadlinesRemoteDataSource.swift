import Foundation

class GetHeadlinesRemoteDataSource {
    private let httpClient: HTTPClient
    private let decoder: JSONDecoderWrapper
    private let apiKey: String
    
    init(httpClient: HTTPClient, decoder: JSONDecoderWrapper, apiKey: String) {
        self.httpClient = httpClient
        self.decoder = decoder
        self.apiKey = apiKey
    }
}

extension GetHeadlinesRemoteDataSource: GetHeadlinesRemoteDataSourceType {
    func fetchHeadlines(page: Int, pageSize: Int) async throws(HTTPClientError) -> HeadlineResponseDTO {
        let endpoint = Endpoint(
            path: "top-headlines",
            queryParameters: [
                "country": "us",
                "pageSize": "\(pageSize)",
                "page": "\(page)",
                "apiKey": "\(self.apiKey)"
            ],
            method: .get
        )
        
        let result = try await httpClient.makeRequest(endPoint: endpoint, baseURL: "https://newsapi.org/v2/")
        
        let headlineResponse = try decoder.decode(HeadlineResponseDTO.self, from: result)
        
        return headlineResponse
    }
}
