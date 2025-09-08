import Foundation

class ArticleRepository {
    let localDataSource: LikedArticlesPersistanceDataSourceType
    
    init(localDataSource: LikedArticlesPersistanceDataSourceType) {
        self.localDataSource = localDataSource
    }
}

typealias ArticleRepositoryType = ArticleSaveRepositoryType & ArticleStatusRepositoryType & DeleteArticleRepositoryType

extension ArticleRepository: ArticleRepositoryType {
    func saveArticle(likedArticle: HeadlineItemEntity) async {
        await localDataSource.saveArticle(likedArticle: likedArticle)
    }
    
    func getArticleStatus(articleId: String) async -> Bool {
        await localDataSource.getArticleStatus(articleId: articleId)
    }
    
    func deleteLikedArticle(articleId: String) async {
        await localDataSource.deleteLikedArticle(articleId: articleId)
    }
}
