import Foundation

class HeadlinesFactory {
    @MainActor
    static func create() -> HeadlinesView {
        HeadlinesView(viewModel: createViewModel())
    }

    @MainActor
    private static func createViewModel() -> HeadlinesViewModel {
        HeadlinesViewModel(
            useCase: createUseCase(),
            errorMapper: HeadlinesPresentableErrorMapper()
        )
    }

    private static func createUseCase() -> GetHeadlinesUseCaseType {
        GetHeadlinesUseCase(
            repository: createRepository(),
            presentationMapper: HeadlinesPresentationMapper()
        )
    }
    
    private static func createRepository() -> GetHeadlinesRepositoryType {
        GetHeadlinesRepository(
            remoteDataSource: createDataSource(),
            domainMapper: HeadlinesDomainMapper(),
            errorMapper: HeadlinesDomainErrorMapper()
        )
    }
    
    private static func createDataSource() -> GetHeadlinesRemoteDataSourceType {
        if let apiKey = Bundle.main.infoDictionary?["NEWS_API_KEY"] as? String {
            return GetHeadlinesRemoteDataSource(
                httpClient: createHTTPClient(),
                decoder: JSONDecoderWrapper(),
                apiKey: apiKey
            )
        }
        return GetHeadlinesRemoteDataSource(
            httpClient: createHTTPClient(),
            decoder: JSONDecoderWrapper(),
            apiKey: ""
        )
    }
    
    private static func createHTTPClient() -> HTTPClient {
        URLSessionHTTPClient(
            requestMaker: URLSessionRequestMaker(),
            errorResolver: URLSessionErrorResolver()
        )
    }
}
