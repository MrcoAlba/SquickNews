import Foundation

class HeadlinesDomainErrorMapper {
    func map(error: HTTPClientError?) -> DomainError {
        switch error {
        case .tooManyRequests: return .tooManyRequests
        case .clientError:     return .invalidParameters
        case .serverError:     return .server
        case .parsingError:    return .generic
        case .badURL:          return .invalidParameters
        case .responseError:   return .generic
        case .generic, .none:  return .generic
        }
    }
}
