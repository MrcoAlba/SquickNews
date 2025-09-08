import Foundation

class ArticlePresentationMapper {
    func map(headlineItemEntity: HeadlineItemEntity) -> HeadlineItem {
        HeadlineItem(
            id: headlineItemEntity.id,
            title: headlineItemEntity.title,
            snippet: headlineItemEntity.snippet,
            url: headlineItemEntity.url,
            imageURL: headlineItemEntity.imageURL,
            source: headlineItemEntity.source,
            publishedAt: headlineItemEntity.publishedAt
        )
    }
}
