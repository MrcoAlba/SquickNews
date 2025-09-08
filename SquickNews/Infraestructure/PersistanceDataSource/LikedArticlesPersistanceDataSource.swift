import Foundation

class LikedArticlesPersistanceDataSource {
    private let container: SwiftDataContainerType
    
    init(container: SwiftDataContainerType) {
        self.container = container
    }
}

extension LikedArticlesPersistanceDataSource: LikedArticlesPersistanceDataSourceType {
    func getArticleStatus(articleId: String) async -> Bool {
        await container.fetchArticleStatus(articleId: articleId)
    }
    
    func deleteLikedArticle(articleId: String) async {
        await container.deleteLikedArticle(articleId: articleId)
    }
    
    func saveArticle(likedArticle: HeadlineItemEntity) async {
        await container.saveArticle(likedArticle: LikedArticle(from: likedArticle))
    }
    
    func fetchLikedArticles() async -> [HeadlineItemEntity] {
        await container.fetchLikedArticles().map {
            HeadlineItemEntity(
                id: $0.id,
                title: $0.title,
                snippet: $0.snippet,
                url: $0.url,
                imageURL: $0.imageURL,
                source: $0.source,
                publishedAt: $0.publishedAt
            )
        }
    }
    
    
}
