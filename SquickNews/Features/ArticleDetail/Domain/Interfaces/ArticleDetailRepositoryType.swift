import Foundation

protocol ArticleStatusRepositoryType {
    func getArticleStatus(articleId: String) async -> Bool
}
protocol DeleteArticleRepositoryType {
    func deleteLikedArticle(articleId: String) async
}
protocol ArticleSaveRepositoryType {
    func saveArticle(likedArticle: HeadlineItemEntity) async
}
