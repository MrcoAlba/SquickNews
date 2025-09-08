import Foundation
import Testing
@testable import SquickNews

struct ArticleRepositoryTests {

    // MARK: - Test Double

    final class LocalMock: LikedArticlesPersistanceDataSourceType {
        var saved: HeadlineItemEntity?
        var statusIDs: [String] = []
        var deletedIDs: [String] = []
        var liked: Set<String> = []
        var likedEntities: [HeadlineItemEntity] = []

        func getArticleStatus(articleId: String) async -> Bool {
            statusIDs.append(articleId)
            return liked.contains(articleId)
        }
        func deleteLikedArticle(articleId: String) async {
            deletedIDs.append(articleId)
            liked.remove(articleId)
        }
        func saveArticle(likedArticle: HeadlineItemEntity) async {
            saved = likedArticle
            liked.insert(likedArticle.id)
        }
        func fetchLikedArticles() async -> [HeadlineItemEntity] { likedEntities }
    }

    // MARK: - Fixtures

    func makeEntity(_ id: String = "id") -> HeadlineItemEntity {
        HeadlineItemEntity(
            id: id, title: "t", snippet: "s",
            url: URL(string: "https://example.com"),
            imageURL: nil, source: "src", publishedAt: Date()
        )
    }

    @Test func save_delegates_to_local() async throws {
        // Given
        let local = LocalMock()
        let sut = ArticleRepository(localDataSource: local)

        // When
        await sut.saveArticle(likedArticle: makeEntity("x1"))

        // Then
        #expect(local.saved?.id == "x1")
        #expect(local.liked.contains("x1"))
    }

    @Test func status_delegates_to_local() async throws {
        // Given
        let local = LocalMock()
        local.liked = ["a", "b"]
        let sut = ArticleRepository(localDataSource: local)

        // When
        let s1 = await sut.getArticleStatus(articleId: "a")
        let s2 = await sut.getArticleStatus(articleId: "z")

        // Then
        #expect(s1 == true)
        #expect(s2 == false)
        #expect(local.statusIDs == ["a", "z"])
    }

    @Test func delete_delegates_to_local() async throws {
        // Given
        let local = LocalMock()
        local.liked = ["k1", "k2"]
        let sut = ArticleRepository(localDataSource: local)

        // When
        await sut.deleteLikedArticle(articleId: "k2")

        // Then
        #expect(!local.liked.contains("k2"))
        #expect(local.deletedIDs == ["k2"])
    }

    @Test func getArticles_delegates_to_local() async throws {
        // Given
        let local = LocalMock()
        local.likedEntities = [makeEntity("m1"), makeEntity("m2")]
        let sut = ArticleRepository(localDataSource: local)

        // When
        let out = await sut.getArticles()

        // Then
        #expect(out.map(\.id) == ["m1", "m2"])
    }
}
