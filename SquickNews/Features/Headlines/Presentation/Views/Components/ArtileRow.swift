import SwiftUI

struct ArticleRow: View {
    let item: HeadlineItem
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: item.imageURL)
            { phase in
                switch phase {
                case .empty:
                    Rectangle().fill(.secondary.opacity(0.2)).overlay {
                        Image("notfoundimage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 88, height: 88)
                    }
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Rectangle().fill(.secondary.opacity(0.2)).overlay {
                        Image("notfoundimage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 88, height: 88)
                    }
                @unknown default:
                    Rectangle().fill(.secondary.opacity(0.2))
                }
            }
            .frame(width: 88, height: 88)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(item.snippet)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    Text(item.source).font(.caption).foregroundStyle(.secondary)
                    Circle().frame(width: 3, height: 3).foregroundStyle(.secondary.opacity(0.6))
                    Text(item.publishedAt.relativeString).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.title). \(item.source), \(item.publishedAt.relativeString)")
    }
}

#Preview {
    AppRouter()
}
