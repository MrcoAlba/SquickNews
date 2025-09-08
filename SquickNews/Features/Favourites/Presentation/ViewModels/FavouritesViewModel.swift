import Foundation

class FavouritesViewModel: ObservableObject {
    @Published var items: [HeadlineItem] = []
    private let getFavouriteArticlesUseCase: GetFavouriteArticlesUseCaseType

    init(getFavouriteArticlesUseCase: GetFavouriteArticlesUseCaseType) {
        self.getFavouriteArticlesUseCase = getFavouriteArticlesUseCase
    }

    func load() async {
        let result = await getFavouriteArticlesUseCase.execute()
        await MainActor.run {
            items = result
        }
    }
}
