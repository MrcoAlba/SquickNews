import SwiftUI

@MainActor
struct AppRouter: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some View {
        TabView {
            NavigationStack {
                HeadlinesFactory.create()
            }
            .tabItem { Label(String(localized: "tab.headlines"), systemImage: "newspaper") }

            NavigationStack {
                FavouritesFactory.create()
            }
            .tabItem { Label(String(localized: "tab.favorites"), systemImage: "star") }
        }
        .fullScreenCover(isPresented: Binding(
            get: { !hasCompletedOnboarding },
            set: { if !$0 { hasCompletedOnboarding = true } }
        )) {
            OnboardingFlowCoordinator(vm: OnboardingFlowViewModel(screens: OnboardingScreenContent.content)) {
                hasCompletedOnboarding = true
            }
        }
    }
}
