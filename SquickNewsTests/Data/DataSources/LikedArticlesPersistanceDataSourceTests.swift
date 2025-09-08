import Foundation
import Testing
@testable import SquickNews

struct LikedArticlesPersistanceDataSourceTests {

    // MARK: - Test Double

    final class ContainerMock: SwiftDataContainerType {
        var statusForID: [String: Bool] = [:]
        var saved: [LikedArticle] = []
        var deletedIDs: [String] = []
        var stored: [LikedArticle] = []

        func fetchArticleStatus(articleId: String) async -> Bool { statusForID[articleId] ?? false }
        func deleteLikedArticle(articleId: String) async {
            deletedIDs.append(articleId)
            stored.removeAll { $0.id == articleId }
        }
        func saveArticle(likedArticle: LikedArticle) async {
            saved.append(likedArticle)
            stored.removeAll { $0.id == likedArticle.id }
            stored.append(likedArticle)
        }
        func fetchLikedArticles() async -> [LikedArticle] { stored }
    }

    // MARK: - Fixtures

    func makeEntity(id: String = "id-1") -> HeadlineItemEntity {
        HeadlineItemEntity(
            id: id,
            title: "T",
            snippet: "S",
            url: URL(string: "https://example.com"),
            imageURL: URL(string: "https://picsum.photos/200"),
            source: "SRC",
            publishedAt: Date(timeIntervalSince1970: 1_700_000_000)
        )
    }

    @Test func get_status_delegates_to_container() async {
        // Given
        let container = ContainerMock()
        container.statusForID = ["a": true, "b": false]
        let sut = LikedArticlesPersistanceDataSource(container: container)

        // When
        let s1 = await sut.getArticleStatus(articleId: "a")
        let s2 = await sut.getArticleStatus(articleId: "b")
        let s3 = await sut.getArticleStatus(articleId: "c")

        // Then
        #expect(s1 == true)
        #expect(s2 == false)
        #expect(s3 == false)
    }

    @Test func save_maps_entity_into_likedArticle_and_persists() async {
        // Given
        let container = ContainerMock()
        let sut = LikedArticlesPersistanceDataSource(container: container)
        let entity = makeEntity(id: "X1")

        // When
        await sut.saveArticle(likedArticle: entity)

        // Then
        #expect(container.saved.count == 1)
        let saved = container.saved.first!
        #expect(saved.id == "X1")
        #expect(saved.title == entity.title)
        #expect(saved.url == entity.url)
        #expect(saved.source == entity.source)

        let all = await sut.fetchLikedArticles()
        #expect(all.count == 1)
        #expect(all.first?.id == "X1")
    }

    @Test func delete_forwards_to_container() async {
        // Given
        let container = ContainerMock()
        container.stored = [LikedArticle(from: makeEntity(id: "D1"))]
        let sut = LikedArticlesPersistanceDataSource(container: container)

        // When
        await sut.deleteLikedArticle(articleId: "D1")

        // Then
        #expect(container.deletedIDs == ["D1"])
        let all = await sut.fetchLikedArticles()
        #expect(all.isEmpty)
    }

    @Test func fetchLikedArticles_maps_back_to_entities() async {
        // Given
        let container = ContainerMock()
        container.stored = [
            LikedArticle(from: makeEntity(id: "A")),
            LikedArticle(from: makeEntity(id: "B"))
        ]
        let sut = LikedArticlesPersistanceDataSource(container: container)

        // When
        let out = await sut.fetchLikedArticles()

        // Then
        #expect(out.map(\.id) == ["A", "B"])
        #expect(out.first?.title == "T")
        #expect(out.first?.source == "SRC")
    }
}
