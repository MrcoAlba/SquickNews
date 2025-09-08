import Foundation

protocol GetHeadlinesRepositoryType {
    func getHeadlines(page: Int, pageSize: Int) async throws(DomainError) -> HeadlinesInfoEntity
}
