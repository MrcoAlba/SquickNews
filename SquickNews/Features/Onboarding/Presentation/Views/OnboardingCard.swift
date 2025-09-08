import SwiftUI
import LibraryUI

struct OnboardingCard<Content: View>: View {
    let cardContent: OnboardingScreenCardContent
    let progress: Double
    @ViewBuilder var content: Content
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            BrandHeader()
            
            Spacer()
            
            Image(cardContent.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            Spacer()
            
            Text(cardContent.headline.uppercased())
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            
            VStack(alignment: .leading, spacing: 10) {
                content
            }
            
            Spacer()
            
            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .padding([.top, .horizontal])
                .accessibilityValue("\(Int(progress * 100)) percent")
            
            LUIButton(title: cardContent.ctaTitle, action: onTap)
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    OnboardingCard(
        cardContent: .mock,
        progress: 1.0/3.0,
    ) {
        Bullet(
            bulletContent: .mock
        )
    } onTap: {
        print("testing on preview")
    }
}

