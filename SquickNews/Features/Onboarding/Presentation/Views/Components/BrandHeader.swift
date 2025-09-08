import SwiftUI

struct BrandHeader: View {
    var body: some View {
        HStack {
            Text("SquickNews")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
    }
}

#Preview {
    BrandHeader()
        .background(.red)
}
