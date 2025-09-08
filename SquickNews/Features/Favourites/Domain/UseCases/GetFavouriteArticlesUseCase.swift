import Foundation

protocol GetFavouriteArticlesUseCaseType {
    func execute() async -> [HeadlineItem]
}

class GetFavouriteArticlesUseCase {
    private let repository: GetArticlesRepositoryType
    private let presentationMapper: ArticlePresentationMapper
    
    init(repository: GetArticlesRepositoryType, presentationMapper: ArticlePresentationMapper) {
        self.repository = repository
        self.presentationMapper = presentationMapper
    }
}

extension GetFavouriteArticlesUseCase: GetFavouriteArticlesUseCaseType {
    func execute() async -> [HeadlineItem] {
        await repository.getArticles().map(presentationMapper.map)
    }
}
