import SwiftUI

struct Bullet: View {
    let bulletContent: OnboardingScreenBulletContent
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(bulletContent.icon)
                    .font(.headline)
                Text(bulletContent.title)
                    .font(.headline)
            }
            Text(bulletContent.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    OnboardingCard(
        cardContent: OnboardingScreenCardContent(
            imageName: "",
            headline: "",
            ctaTitle: ""
        ),
        progress: 1.0/3.0
    ) {
        Bullet(
            bulletContent: .mock
        )
    } onTap: {
        print("testing on preview")
    }
}
