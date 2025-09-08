import SwiftUI

struct OnboardingFlowCoordinator: View {
    @StateObject private var vm: OnboardingFlowViewModel
    @State private var drag: CGFloat = .zero
    let finish: () -> Void
    
    init(vm: OnboardingFlowViewModel, finish: @escaping () -> Void) {
        self._vm = .init(wrappedValue: vm)
        self.finish = finish
    }
    
    var body: some View {
        VStack {
            OnboardingScreen(
                content: vm.content,
                progress: vm.progress,
                onContinue: { vm.isLast ? finish() : vm.next() }
            )
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal:   .move(edge: .leading).combined(with: .opacity)
            ))
            .animation(.easeInOut(duration: 0.22), value: vm.step)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { drag = $0.translation.width }
                    .onEnded { value in
                        defer { drag = .zero }
                        let t: CGFloat = 60
                        if value.translation.width < -t {
                            vm.isLast ? finish() : vm.next()
                        } else if value.translation.width > t {
                            vm.back()
                        }
                    }
            )
        }
    }
}

#Preview {
    OnboardingFlowCoordinator(vm: OnboardingFlowViewModel()) {
        print("holi")
    }
}
