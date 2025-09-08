import SwiftUI

struct FavouritesView: View {
    @State private var path = NavigationPath()
    @StateObject var viewModel: FavouritesViewModel
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if viewModel.items.isEmpty {
                    ContentUnavailableView("No favourites yet",
                                           systemImage: "star",
                                           description: Text("Save articles from the detail screen."))
                } else {
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
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "Favourites"))
            .onAppear { Task { await viewModel.load() } }
            .navigationDestination(for: HeadlineItem.self) { item in
                ArticleDetailFactory.create(from: item)
            }
        }
    }
}
