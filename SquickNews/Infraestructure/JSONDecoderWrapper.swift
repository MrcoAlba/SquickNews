import Foundation

final class JSONDecoderWrapper {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws(HTTPClientError) -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw HTTPClientError.parsingError
        }
    }
}
