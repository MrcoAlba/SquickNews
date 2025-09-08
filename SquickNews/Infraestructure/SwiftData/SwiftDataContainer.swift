import Foundation
import SwiftData

class SwiftDataContainer: SwiftDataContainerType {
    static let shared = SwiftDataContainer()
    private let container: ModelContainer
    private let context: ModelContext
    
    private init() {
        let scheme = Schema([LikedArticle.self])
        container = try! ModelContainer(for: scheme, configurations: [])
        context = ModelContext(container)
    }
    
    func fetchArticleStatus(articleId: String) async -> Bool {
        let descriptor = FetchDescriptor<LikedArticle>(
            predicate: #Predicate { $0.id == articleId },
            sortBy: []
        )
        do {
            return try context.fetch(descriptor).first != nil
        } catch {
            return false
        }
    }
    
    func deleteLikedArticle(articleId: String) async {
        let descriptor = FetchDescriptor<LikedArticle>(
            predicate: #Predicate { $0.id == articleId },
            sortBy: []
        )
        do {
            if let existing = try context.fetch(descriptor).first {
                context.delete(existing)
                try? context.save()
            }
        } catch {
            
        }
    }
    
    func saveArticle(likedArticle: LikedArticle) async {
        context.insert(likedArticle)
        try? context.save()
    }
    
    func fetchLikedArticles() async -> [LikedArticle] {
        let descriptor = FetchDescriptor<LikedArticle>(
            sortBy: [SortDescriptor(\.publishedAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }
}
