import SwiftUI
import SafariServices
import LibraryUI

struct ArticleDetailView: View {
    @StateObject var viewModel: ArticleDetailViewModel
    @State private var showSafari = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                AsyncImage(url: viewModel.articleDetail.imageURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(.secondary.opacity(0.2)).frame(height: 220)
                    case .success(let image):
                        image.resizable().scaledToFill().frame(maxWidth: .infinity, minHeight: 220).clipped()
                    case .failure:
                        Rectangle().fill(.secondary.opacity(0.2)).frame(height: 220)
                            .overlay(Image("notfoundimage").resizable().scaledToFit().padding())
                    @unknown default:
                        Rectangle().fill(.secondary.opacity(0.2)).frame(height: 220)
                    }
                }
                .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.articleDetail.title)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text(viewModel.articleDetail.snippet)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if let url = viewModel.articleDetail.url {
                    
                    LUIButton(title: "Read full article", style: .outlined) {
                        showSafari = true
                    }
                    .sheet(isPresented: $showSafari) {
                        SafariView(url: url)
                            .ignoresSafeArea()
                    }
                    
                    
                }
                LUIButton(title: viewModel.isLiked ? "Liked article :)" : "Add to Favourites", style: .outlined) {
                    Task {
                        await viewModel.likeButtonPressed()
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .contain)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await self.viewModel.getArticleStatus()
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}
