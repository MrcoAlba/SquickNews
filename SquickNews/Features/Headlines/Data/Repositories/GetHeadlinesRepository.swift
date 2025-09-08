import Foundation

class GetHeadlinesRepository {
    private let remoteDataSource: GetHeadlinesRemoteDataSourceType
    private let domainMapper: HeadlinesDomainMapper
    private let errorMapper: HeadlinesDomainErrorMapper
    
    init(remoteDataSource: GetHeadlinesRemoteDataSourceType, domainMapper: HeadlinesDomainMapper, errorMapper: HeadlinesDomainErrorMapper) {
        self.remoteDataSource = remoteDataSource
        self.domainMapper = domainMapper
        self.errorMapper = errorMapper
    }
}

extension GetHeadlinesRepository: GetHeadlinesRepositoryType {
    func getHeadlines(page: Int, pageSize: Int) async throws(DomainError) -> HeadlinesInfoEntity {
        do {
            let dto = try await remoteDataSource.fetchHeadlines(page: page, pageSize: pageSize)
            return domainMapper.map(headlineResponseDTOs: dto)
        }
        catch {
            throw errorMapper.map(error: error)
        }
    }
}
