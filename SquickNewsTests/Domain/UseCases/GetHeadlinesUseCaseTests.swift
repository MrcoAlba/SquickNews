import Foundation
import Testing
@testable import SquickNews

struct GetHeadlinesUseCaseTests {

    // MARK: - Test Double

    final class GetHeadlinesRepositoryTypeMock: GetHeadlinesRepositoryType {
        enum Mode { case success(HeadlinesInfoEntity), failure(DomainError) }
        var mode: Mode
        init(_ mode: Mode) { self.mode = mode }

        private(set) var received: (page: Int, pageSize: Int)?
        func getHeadlines(page: Int, pageSize: Int) async throws(DomainError) -> HeadlinesInfoEntity {
            received = (page, pageSize)
            switch mode {
            case .success(let e): return e
            case .failure(let err): throw err
            }
        }
    }

    // MARK: - Fixtures

    let presentationMapper = HeadlinesPresentationMapper()

    func makeEntity(_ dates: [Date]) -> HeadlinesInfoEntity {
        HeadlinesInfoEntity(
            status: "ok",
            totalResults: dates.count,
            articles: dates.enumerated().map { i, d in
                HeadlineItemEntity(
                    id: "id\(i)",
                    title: "T\(i)",
                    snippet: "S\(i)",
                    url: URL(string: "https://example.com/\(i)"),
                    imageURL: URL(string: "https://picsum.photos/id/\(i)/200"),
                    source: "SRC",
                    publishedAt: d
                )
            }
        )
    }

    @Test func executes_repo_and_sorts_desc_by_publishedAt() async throws {
        // Given
        let now = Date()
        let e = makeEntity([now.addingTimeInterval(-100), now, now.addingTimeInterval(-50)])
        let repo = GetHeadlinesRepositoryTypeMock(.success(e))
        let sut = GetHeadlinesUseCase(repository: repo, presentationMapper: presentationMapper)

        // When
        let out = try await sut.execute(page: 2, pageSize: 10)

        // Then
        #expect(repo.received?.page == 2)
        #expect(repo.received?.pageSize == 10)
        let dates = out.articles.map(\.publishedAt)
        #expect(dates == dates.sorted(by: >))
        #expect(out.totalResults == e.totalResults)
        #expect(out.status == "ok")
    }

    @Test func propagates_domain_error_from_repo() async {
        // Given
        let repo = GetHeadlinesRepositoryTypeMock(.failure(.tooManyRequests))
        let sut = GetHeadlinesUseCase(repository: repo, presentationMapper: presentationMapper)

        // When / Then
        await #expect(throws: DomainError.tooManyRequests) {
            _ = try await sut.execute(page: 1, pageSize: 10)
        }
    }
}
