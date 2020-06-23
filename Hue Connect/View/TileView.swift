
import SwiftUI
/// Tile view based on color and selection
struct TileView: View {
    /// View color
    var color: Color
    /// Is the tile view selected
    var isSelected: Bool
    /// SwiftUI view
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(color)
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 5))
                    .opacity(isSelected ? 0.9 : 0))
                
        
    }
    
}
