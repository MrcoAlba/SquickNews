import Foundation

protocol GetHeadlinesRemoteDataSourceType {
    func fetchHeadlines(page: Int, pageSize: Int) async throws(HTTPClientError) -> HeadlineResponseDTO
}
