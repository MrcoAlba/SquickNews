import Foundation

struct HeadlinesPresentableContent {
    let status: String
    let totalResults: Int
    let articles: [HeadlineItem]
}

struct HeadlineItem: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let snippet: String
    let url: URL?
    let imageURL: URL?
    let source: String
    let publishedAt: Date
}
