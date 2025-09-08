import Foundation

protocol GetArticlesRepositoryType {
    func getArticles() async -> [HeadlineItemEntity]
}
