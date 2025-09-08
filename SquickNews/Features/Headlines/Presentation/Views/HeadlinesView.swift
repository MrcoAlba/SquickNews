import SwiftUI
import LibraryUI

struct HeadlinesView: View {
    @State private var path = NavigationPath()
    @StateObject var viewModel: HeadlinesViewModel
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.items) { item in
                            ArticleRow(item: item)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .onTapGesture {
                                    path.append(item)
                                }
                        }
                        
                        if viewModel.canLoadMore {
                            Divider()
                                .onAppear {
                                    Task { await viewModel.loadMore() }
                                }
                        }
                        if viewModel.headlinesSize != nil && viewModel.limitReached {
                            Text("You reached the end of the headlines. \nTotal: " + String(viewModel.headlinesSize!))
                                .font(.headline)
                                .italic()
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                        }
                    }
                }
                .refreshable { await viewModel.refresh() }
                
                if viewModel.showLoadingSpinner && viewModel.items.isEmpty {
                    ProgressView()
                        .scaleEffect(1.2)
                }
            }
            .navigationTitle(String(localized: "Headlines"))
            .task { await viewModel.initialLoadIfNeeded() }
            .alert(isPresented: .constant(viewModel.showErrorMessage != nil)) {
                Alert(
                    title: Text(String(localized: "Error")),
                    message: Text(viewModel.showErrorMessage ?? ""),
                    dismissButton: .default(Text(String(localized: "OK"))) {
                        viewModel.showErrorMessage = nil
                    }
                )
            }
            .navigationDestination(for: HeadlineItem.self) { item in
                ArticleDetailFactory.create(from: item)
            }
        }
    }
}

#Preview {
    AppRouter()
}
