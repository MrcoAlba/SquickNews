import SwiftUI

enum ArticleDetailFactory {
    static func create(from item: HeadlineItem) -> some View {
        ArticleDetailView(viewModel: createViewmodel(item: item))
    }
    
    private static func createViewmodel(item: HeadlineItem) -> ArticleDetailViewModel {
        ArticleDetailViewModel(
            articleDetail: item,
            getArticleStatusUseCase: createGetArticleStatusUseCase(),
            deleteArticleStatusUseCase: createDeleteArticleStatusUseCase(),
            saveArticleUseCase: createSaveArticleUseCase()
        )
    }
    
    private static func createGetArticleStatusUseCase() -> GetArticleStatusUseCaseType {
        GetArticleStatusUseCase(
            repository: createRepository(),
            presentationMapper: headlinesPresentationMapper
        )
    }
    private static func createDeleteArticleStatusUseCase() -> DeleteArticleStatusUseCaseType {
        DeleteArticleStatusUseCase(
            repository: createRepository(),
            presentationMapper: headlinesPresentationMapper
        )
    }
    private static func createSaveArticleUseCase() -> SaveArticleUseCaseType {
        SaveArticleUseCase(
            repository: createRepository(),
            presentationMapper: headlinesPresentationMapper
        )
    }
    
    private static let headlinesPresentationMapper = HeadlinesPresentationMapper()
    
    private static func createRepository() -> ArticleRepositoryType {
        ArticleRepository(localDataSource: createDataSource())
    }
    
    private static func createDataSource() -> LikedArticlesPersistanceDataSourceType {
        LikedArticlesPersistanceDataSource(container: createSwiftDataContainerType())
    }
    
    private static func createSwiftDataContainerType() -> SwiftDataContainerType {
        SwiftDataContainer.shared
    }
    
}
