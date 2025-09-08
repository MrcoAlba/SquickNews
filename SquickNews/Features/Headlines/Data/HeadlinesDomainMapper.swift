import Foundation

class HeadlinesDomainMapper {
    func map(headlineResponseDTOs: HeadlineResponseDTO) -> HeadlinesInfoEntity {
        HeadlinesInfoEntity(
            status: headlineResponseDTOs.status,
            totalResults: headlineResponseDTOs.totalResults,
            articles: headlineResponseDTOs.articles.map { itemDTO in
                HeadlineItemEntity(
                    id: itemDTO.url ?? UUID().uuidString,
                    title: itemDTO.title ?? "No title available",
                    snippet: itemDTO.description ?? "No description available",
                    url: URL(string: itemDTO.url ?? ""),
                    imageURL: URL(string: itemDTO.urlToImage ?? ""),
                    source: itemDTO.source?.name ?? "No source available",
                    publishedAt: {
                        let iso = ISO8601DateFormatter()
                        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                        return (itemDTO.publishedAt.flatMap { iso.date(from: $0) })
                        ?? ISO8601DateFormatter().date(from: itemDTO.publishedAt ?? "")
                        ?? Date()
                    }()
                )
            }
        )
    }
}
