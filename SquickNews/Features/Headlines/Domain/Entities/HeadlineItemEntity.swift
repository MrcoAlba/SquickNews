import Foundation

struct HeadlinesInfoEntity {
    let status: String
    let totalResults: Int
    let articles: [HeadlineItemEntity]
}

struct HeadlineItemEntity {
    let id: String
    let title: String
    let snippet: String
    let url: URL?
    let imageURL: URL?
    let source: String
    let publishedAt: Date
}
