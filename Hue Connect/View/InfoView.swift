
import SwiftUI

/// Generate a rainbow text from the info
struct InfoView: View {
    /// Info to be displayed
    var info: String
    /// SwiftUI view
    var body: some View {
        Text(info)
        .font(.system(size: 50, weight: .black, design: .rounded))
        .overlay(LinearGradient(gradient: Gradient(colors: [.red, .red, .orange, .yellow, .green, .blue, .purple, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .mask(Text(info)
            .font(.system(size: 50, weight: .black, design: .rounded))
            .scaledToFill())
    }
}
