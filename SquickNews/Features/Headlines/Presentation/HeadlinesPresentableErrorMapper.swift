import Foundation

class HeadlinesPresentableErrorMapper {
    func map(_ error: DomainError?) -> String {
        guard error == .tooManyRequests else {
            return "Something went wrong"
        }
        return "You have exceeded the limit. Try again later"
    }
}
