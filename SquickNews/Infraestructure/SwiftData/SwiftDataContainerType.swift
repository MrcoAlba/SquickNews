import Foundation

protocol SwiftDataContainerType {
    func fetchArticleStatus(articleId: String) async -> Bool
    func deleteLikedArticle(articleId: String) async
    func saveArticle(likedArticle: LikedArticle) async
    func fetchLikedArticles() async -> [LikedArticle]
}
