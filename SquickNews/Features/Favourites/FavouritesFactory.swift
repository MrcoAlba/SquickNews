import Foundation

class FavouritesFactory {
    static func create() -> FavouritesView {
        FavouritesView(viewModel: createViewModel())
    }
    
    private static func createViewModel() -> FavouritesViewModel {
        FavouritesViewModel(getFavouriteArticlesUseCase: createUseCase())
    }
    
    private static func createUseCase() -> GetFavouriteArticlesUseCaseType {
        GetFavouriteArticlesUseCase(
            repository: createRepository(),
            presentationMapper: ArticlePresentationMapper()
        )
    }
    
    private static func createRepository() -> GetArticlesRepositoryType {
        ArticleRepository(localDataSource: createDataSource())
    }
    
    private static func createDataSource() -> LikedArticlesPersistanceDataSourceType {
        LikedArticlesPersistanceDataSource(container: createSwiftDataContainerType())
    }
    
    private static func createSwiftDataContainerType() -> SwiftDataContainerType {
        SwiftDataContainer.shared
    }
}
