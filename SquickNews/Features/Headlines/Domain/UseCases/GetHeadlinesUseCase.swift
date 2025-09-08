import Foundation

protocol GetHeadlinesUseCaseType {
    func execute(page: Int, pageSize: Int) async throws(DomainError) -> HeadlinesPresentableContent
}

class GetHeadlinesUseCase {
    private let repository: GetHeadlinesRepositoryType
    private let presentationMapper: HeadlinesPresentationMapper
    
    init(repository: GetHeadlinesRepositoryType, presentationMapper: HeadlinesPresentationMapper) {
        self.repository = repository
        self.presentationMapper = presentationMapper
    }
}

extension GetHeadlinesUseCase: GetHeadlinesUseCaseType {
    public func execute(page: Int, pageSize: Int) async throws(DomainError) -> HeadlinesPresentableContent {
        let response = try await repository.getHeadlines(page: page, pageSize: pageSize)
        
        return presentationMapper.map(
            headlinesInfoEntity: HeadlinesInfoEntity(
                status: response.status,
                totalResults: response.totalResults,
                articles: response.articles.sorted { $0.publishedAt > $1.publishedAt }
            )
        )
    }
}
