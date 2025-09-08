import Foundation

struct OnboardingScreenContent {
    let cardContent: OnboardingScreenCardContent
    let bulletContent: OnboardingScreenBulletContent
}

struct OnboardingScreenCardContent {
    let imageName: String
    let headline: String
    let ctaTitle: String
}

struct OnboardingScreenBulletContent {
    let icon: String
    let title: String
    let subtitle: String
}

extension OnboardingScreenContent {
    static let mock: OnboardingScreenContent = .init(
        cardContent: .mock,
        bulletContent: .mock
    )
    
    static let content: [OnboardingScreenContent] = [
        .init(
            cardContent: .content[0],
            bulletContent: .content[0]
        ),
        .init(
            cardContent: .content[1],
            bulletContent: .content[1]
        ),
        .init(
            cardContent: .content[2],
            bulletContent: .content[2]
        )
    ]
}

extension OnboardingScreenCardContent {
    static let mock = OnboardingScreenCardContent(
        imageName: "obimage1",
        headline: "STAY IN THE LOOP\nTHE SQUIRREL WAY",
        ctaTitle: "CONTINUE"
    )
    
    static let content: [OnboardingScreenCardContent] = [
        .init(
            imageName: "obimage1",
            headline: "STAY IN THE LOOP THE SQUIRREL WAY",
            ctaTitle: "CONTINUE"
        ),
        .init(
            imageName: "obimage2",
            headline: "QUICK NEWS\nYOUR WAY",
            ctaTitle: "CONTINUE"
        ),
        .init(
            imageName: "obimage3",
            headline: "YOUR NEST\nYOUR RULES",
            ctaTitle: "GET STARTED"
        )
    ]}

extension OnboardingScreenBulletContent {
    static let mock: OnboardingScreenBulletContent = .init(
        icon: "📰",
        title: "Feed",
        subtitle: "Top stories, one smart scroll"
    )
    
    static let content: [OnboardingScreenBulletContent] = [
        .init(
            icon: "📰",
            title: "Feed",
            subtitle: "Top stories, one smart scroll"
        ),
        .init(
            icon: "⭐️",
            title: "Favorites",
            subtitle: "Save the stories you love for later"
        ),
        .init(
            icon: "🔍",
            title: "Search",
            subtitle: "Find the news that matters to you"
        )
    ]
}
