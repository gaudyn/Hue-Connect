
import SwiftUI

/// Generate a rainbow text from the info
struct InfoView: View {
    var info: String
    var body: some View {
        Text(info)
        .font(.system(size: 50, weight: .black, design: .rounded))
        .overlay(LinearGradient(gradient: Gradient(colors: [.red, .red, .orange, .yellow, .green, .blue, .purple, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .mask(Text(info)
            .font(.system(size: 50, weight: .black, design: .rounded))
            .scaledToFill())
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(info: "Paused")
    }
}
