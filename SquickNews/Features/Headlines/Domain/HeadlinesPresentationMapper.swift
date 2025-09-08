import Foundation

class HeadlinesPresentationMapper {
    func map(headlinesInfoEntity: HeadlinesInfoEntity) -> HeadlinesPresentableContent {
        HeadlinesPresentableContent(
            status: headlinesInfoEntity.status,
            totalResults: headlinesInfoEntity.totalResults,
            articles: headlinesInfoEntity.articles.map { itemEntity in
                HeadlineItem(
                    id: itemEntity.id,
                    title: itemEntity.title,
                    snippet: itemEntity.snippet,
                    url: itemEntity.url,
                    imageURL: itemEntity.imageURL,
                    source: itemEntity.source,
                    publishedAt: itemEntity.publishedAt
                )
            }
        )
    }
}
