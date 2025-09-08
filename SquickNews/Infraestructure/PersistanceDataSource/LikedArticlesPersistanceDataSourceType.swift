import Foundation

protocol LikedArticlesPersistanceDataSourceType {
    func getArticleStatus(articleId: String) async -> Bool
    func deleteLikedArticle(articleId: String) async
    func saveArticle(likedArticle: HeadlineItemEntity) async
    func fetchLikedArticles() async -> [HeadlineItemEntity]
}
