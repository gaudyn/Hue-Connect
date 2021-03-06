
import SwiftUI

/// Progress to next level for the game view
struct NextLevelView: View {
    /// Game reference
    @ObservedObject var game: Game
    /// SwiftUI view
    var body: some View {
        VStack{
            InfoView(info: "Good job!")
            Button(action: {
                self.game.nextLevel()
            }) {
                HStack{
                Image(systemName: "arrow.turn.down.right")
                    
                Text("Next Level")
                }
                .font(.system(size: 30, weight: .medium, design: .rounded))
                .padding()
                .foregroundColor(Color.white)
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .opacity(0.8))
                .cornerRadius(40)
            }
        }
    }
}
