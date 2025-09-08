import Foundation

protocol HTTPClient {
    func makeRequest(endPoint: Endpoint, baseURL: String) async throws(HTTPClientError) -> Data
}
