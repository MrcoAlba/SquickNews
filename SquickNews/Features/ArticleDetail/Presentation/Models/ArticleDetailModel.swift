import Foundation

struct ArticleDetailModel: Identifiable, Equatable {
    let id: String
    let title: String
    let snippet: String
    let url: URL?
    let imageURL: URL?
    let source: String
    let publishedAt: Date
}
