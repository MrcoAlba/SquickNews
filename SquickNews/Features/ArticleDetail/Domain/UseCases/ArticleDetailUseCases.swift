import Foundation

protocol GetArticleStatusUseCaseType {
    func execute(articleId: String) async -> Bool
}

protocol DeleteArticleStatusUseCaseType {
    func execute(articleId: String) async
}

protocol SaveArticleUseCaseType {
    func execute(likedArticle: HeadlineItemEntity) async
}

class GetArticleStatusUseCase: GetArticleStatusUseCaseType {
    private let repository: ArticleStatusRepositoryType
    private let presentationMapper: HeadlinesPresentationMapper
    
    init(repository: ArticleStatusRepositoryType, presentationMapper: HeadlinesPresentationMapper) {
        self.repository = repository
        self.presentationMapper = presentationMapper
    }
    
    func execute(articleId: String) async -> Bool {
        await repository.getArticleStatus(articleId: articleId)
    }
}

class DeleteArticleStatusUseCase: DeleteArticleStatusUseCaseType {
    private let repository: DeleteArticleRepositoryType
    private let presentationMapper: HeadlinesPresentationMapper
    
    init(repository: DeleteArticleRepositoryType, presentationMapper: HeadlinesPresentationMapper) {
        self.repository = repository
        self.presentationMapper = presentationMapper
    }
    
    func execute(articleId: String) async {
        await repository.deleteLikedArticle(articleId: articleId)
    }
}

class SaveArticleUseCase: SaveArticleUseCaseType {
    private let repository: ArticleSaveRepositoryType
    private let presentationMapper: HeadlinesPresentationMapper
    
    init(repository: ArticleSaveRepositoryType, presentationMapper: HeadlinesPresentationMapper) {
        self.repository = repository
        self.presentationMapper = presentationMapper
    }
    
    func execute(likedArticle: HeadlineItemEntity) async {
        await repository.saveArticle(likedArticle: likedArticle)
    }
}
