import Foundation

struct HeadlineResponseDTO: Decodable {
    let status: String
    let totalResults: Int
    let articles: [HeadlineItemDTO]
}

struct HeadlineItemDTO: Decodable {
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let source: SourceDTO?
}

struct SourceDTO: Decodable, Identifiable {
    let id: String?
    let name: String?
}
