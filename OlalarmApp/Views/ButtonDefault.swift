import SwiftUI

struct ButtonDefault: View {
    var text: String
    var systemImage: String? = nil
    var colorText: Color
    var colorBackground: Color
    var maxWidth: CGFloat? = nil
    var cornerRadius: CGFloat = 12
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if systemImage != nil {
                    Image(systemName: self.systemImage!)
                        .font(.title)
                }

                Text(text)
                    .font(.title)
            }
            .frame(maxWidth: maxWidth)
            .foregroundColor(colorText)
            .padding()
            .background(colorBackground)
            .cornerRadius(cornerRadius)
        }
    }
}
