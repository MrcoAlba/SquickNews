import Foundation
import Testing
@testable import SquickNews

struct GetFavouriteArticlesUseCaseTests {

    // MARK: - Test Double

    final class ArticlesRepoMock: GetArticlesRepositoryType {
        var items: [HeadlineItemEntity] = []
        func getArticles() async -> [HeadlineItemEntity] { items }
    }

    @Test func maps_all_entities_to_UI_models() async throws {
        // Given
        let repo = ArticlesRepoMock()
        repo.items = [
            HeadlineItemEntity(
                id: "a1",
                title: "Title 1",
                snippet: "Snippet 1",
                url: URL(string: "https://example.com/1"),
                imageURL: URL(string: "https://picsum.photos/id/1/200"),
                source: "SRC1",
                publishedAt: Date()
            ),
            HeadlineItemEntity(
                id: "a2",
                title: "Title 2",
                snippet: "Snippet 2",
                url: nil,
                imageURL: nil,
                source: "SRC2",
                publishedAt: Date().addingTimeInterval(-10)
            )
        ]
        let sut = GetFavouriteArticlesUseCase(
            repository: repo,
            presentationMapper: ArticlePresentationMapper()
        )

        // When
        let out = await sut.execute()

        // Then
        #expect(out.count == 2)
        #expect(out[0].id == "a1")
        #expect(out[1].title == "Title 2")
        #expect(out[0].url?.absoluteString == "https://example.com/1")
    }
}
