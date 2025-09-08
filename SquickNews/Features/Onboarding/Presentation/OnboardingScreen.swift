import SwiftUI

struct OnboardingScreen: View {
    let content: OnboardingScreenContent
    let progress: Double
    let onContinue: () -> Void
    var body: some View {
        OnboardingCard(
            cardContent: content.cardContent,
            progress: progress,
            content: {
                Bullet(bulletContent: content.bulletContent)
            },
            onTap: onContinue
        )
    }
}

#Preview {
    OnboardingScreen(content: .mock, progress: 1.0/3.0) {
        print("testing Preview")
    }
}
