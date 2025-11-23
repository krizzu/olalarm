import SharedData
import SwiftUI

struct ScreenPage<Content: View>: View {
    var content: Content
    var padding: CGFloat

    init(padding: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.padding = padding
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.colorBackground.ignoresSafeArea()
            content.padding(self.padding)
        }
    }
}

#Preview {
    ScreenPage {
        Text("Hi!")
    }
}
