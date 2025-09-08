import Foundation

class ArticleDetailViewModel: ObservableObject {
    let articleDetail: HeadlineItemEntity
    @Published var isLiked: Bool = false
    
    private let getArticleStatusUseCase: GetArticleStatusUseCaseType
    private let deleteArticleStatusUseCase: DeleteArticleStatusUseCaseType
    private let saveArticleUseCase: SaveArticleUseCaseType

    init(
        articleDetail: HeadlineItem,
        getArticleStatusUseCase: GetArticleStatusUseCaseType,
        deleteArticleStatusUseCase: DeleteArticleStatusUseCaseType,
        saveArticleUseCase: SaveArticleUseCaseType
    ) {
        self.articleDetail = .init(
            id: articleDetail.id,
            title: articleDetail.title,
            snippet: articleDetail.snippet,
            url: articleDetail.url,
            imageURL: articleDetail.imageURL,
            source: articleDetail.source,
            publishedAt: articleDetail.publishedAt
        )
        self.getArticleStatusUseCase = getArticleStatusUseCase
        self.deleteArticleStatusUseCase = deleteArticleStatusUseCase
        self.saveArticleUseCase = saveArticleUseCase
    }
    
    func getArticleStatus() async {
        let liked = await getArticleStatusUseCase.execute(articleId: articleDetail.id)
        await MainActor.run {
            self.isLiked = liked
        }
    }
    
    func likeButtonPressed() async {
        if isLiked {
            await deleteArticle()
        } else {
            await saveArticle()
        }
    }
    
    private func saveArticle() async {
        await saveArticleUseCase.execute(
                likedArticle: articleDetail
        )
        await getArticleStatus()
    }
    
    private func deleteArticle() async {
        await deleteArticleStatusUseCase.execute(articleId: articleDetail.id)
        await getArticleStatus()
    }
}
