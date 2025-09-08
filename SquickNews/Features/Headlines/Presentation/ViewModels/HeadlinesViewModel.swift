import Foundation
import SwiftUI

enum DomainError: Error {
    case generic
    case tooManyRequests
    case unauthorized
    case invalidParameters
    case server
    case network
    case cancelled
}

@MainActor
final class HeadlinesViewModel: ObservableObject {
    @Published var items: [HeadlineItem] = []
    @Published var showLoadingSpinner = false
    @Published var isLoadingMore = false
    @Published var showErrorMessage: String?
    @Published var headlinesSize: Int?

    @Published private(set) var page = 1
    @Published private(set) var canLoadMore = false
    @Published private(set) var limitReached = false

    private let pageSize = 10
    private let useCase: GetHeadlinesUseCaseType
    private let errorMapper: HeadlinesPresentableErrorMapper

    private var isRefreshing = false
    private var currentTask: Task<Void, Never>?

    init(useCase: GetHeadlinesUseCaseType, errorMapper: HeadlinesPresentableErrorMapper) {
        self.useCase = useCase
        self.errorMapper = errorMapper
    }

    func initialLoadIfNeeded() async {
        guard items.isEmpty else { return }
        await refresh()
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true

        currentTask?.cancel()

        showLoadingSpinner = true
        showErrorMessage = nil
        page = 1
        items = []
        canLoadMore = false
        limitReached = false

        currentTask = Task { [page, pageSize] in
            do {
                let result = try await useCase.execute(page: page, pageSize: pageSize)
                guard !Task.isCancelled else { return }
                self.items = result.articles
                self.headlinesSize = result.totalResults
                self.canLoadMore = result.totalResults > page * pageSize
                self.limitReached = !self.canLoadMore
            } catch {
                guard !Task.isCancelled else { return }
                self.items = []
                self.canLoadMore = false
                await self.handleError(error: error as! DomainError)
            }
            self.showLoadingSpinner = false
            self.isRefreshing = false
        }
        await currentTask?.value
    }

    func loadMore() async {
        guard canLoadMore, !isLoadingMore, !isRefreshing else { return }

        isLoadingMore = true
        canLoadMore = false

        let nextPage = page + 1
        currentTask = Task { [pageSize] in
            do {
                let result = try await useCase.execute(page: nextPage, pageSize: pageSize)
                guard !Task.isCancelled else { return }
                self.page = nextPage
                self.items.append(contentsOf: result.articles)
                self.headlinesSize = result.totalResults
                self.canLoadMore = result.totalResults > nextPage * pageSize
                self.limitReached = !self.canLoadMore
            } catch {
                guard !Task.isCancelled else { return }
                await self.handleError(error: error as! DomainError)
            }
            self.isLoadingMore = false
        }
        await currentTask?.value
    }

    private func handleError(error: DomainError?) async {
        showErrorMessage = errorMapper.map(error)
    }
}
