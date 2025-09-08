import SwiftUI

enum OnboardingStep: Int, CaseIterable {
    case first, second, third
}

@MainActor
final class OnboardingFlowViewModel: ObservableObject {
    @Published private(set) var step: OnboardingStep = .first
    @Published private(set) var content: OnboardingScreenContent
    
    private let screens: [OnboardingScreenContent]
    
    init(screens: [OnboardingScreenContent] = OnboardingScreenContent.content) {
        self.screens = screens
        self.content = screens[0]
    }
    
    var index: Int { step.rawValue }
    var isFirst: Bool { step == .first }
    var isLast:  Bool { step == .third }
    
    var progress: Double {
        Double(index + 1) / Double(OnboardingStep.allCases.count)
    }
    
    func next() {
        guard !isLast else { return }
        route(to: .init(rawValue: index + 1) ?? .third)
    }
    
    func back() {
        guard !isFirst else { return }
        route(to: .init(rawValue: index - 1) ?? .first)
    }
    
    private func route(to newStep: OnboardingStep) {
        withAnimation(.easeInOut(duration: 0.25)) {
            step = newStep
            content = screens[newStep.rawValue]
        }
        #if os(iOS)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }
}
