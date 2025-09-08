import Foundation

extension ArticleRepository: GetArticlesRepositoryType {
    func getArticles() async -> [HeadlineItemEntity] {
        await localDataSource.fetchLikedArticles()
    }
}
