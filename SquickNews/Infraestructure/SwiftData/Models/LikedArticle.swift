import Foundation
import SwiftData

@Model
final class LikedArticle {
    @Attribute(.unique) var id: String
    var title: String
    var snippet: String
    var url: URL?
    var imageURL: URL?
    var source: String
    var publishedAt: Date
    
    init(from article: HeadlineItemEntity) {
        self.id = article.id
        self.title = article.title
        self.snippet = article.snippet
        self.url = article.url
        self.imageURL = article.imageURL
        self.source = article.source
        self.publishedAt = article.publishedAt
    }
}
