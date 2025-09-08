import Foundation

class URLSessionHTTPClient {
    private let session: URLSession
    private let requestMaker: URLSessionRequestMaker
    private let errorResolver: URLSessionErrorResolver
    
    init(session: URLSession = .shared,
         requestMaker: URLSessionRequestMaker,
         errorResolver: URLSessionErrorResolver
    ) {
        self.session = session
        self.requestMaker = requestMaker
        self.errorResolver = errorResolver
    }
}

extension URLSessionHTTPClient: HTTPClient {
    func makeRequest(endPoint: Endpoint, baseURL: String) async throws(HTTPClientError) -> Data {
        guard let url = requestMaker.url(endpoint: endPoint, baseURL: baseURL) else {
            throw .badURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                throw HTTPClientError.responseError
            }
            
            guard response.statusCode == 200 else {
                throw errorResolver.resolve(statusCode: response.statusCode)
            }
            
            return data
            
        } catch {
            throw errorResolver.resolve(error: error)
        }
    }
}
