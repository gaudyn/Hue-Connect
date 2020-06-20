
import SwiftUI

/// Navigation buttons for the game: Hint, Reset and Return
struct NavigationButtons: View{
    
    @ObservedObject var game: Game
    @Binding var presentationMode: PresentationMode
    
    var body: some View {
        HStack{
            Button(action: {
                if self.game.state == .active{
                    self.game.pause()
                }else if self.game.state == .paused{
                    self.game.unpause()
                }
            }){
                HStack{
                    Image(systemName: "pause.fill")
                    Text(self.game.state == .paused ? "Resume" : "Pause")
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.gray)
                .cornerRadius(40)
            }
            .opacity(self.game.state == .active || self.game.state == .paused ? 1 : 0.5)
            .disabled(!(self.game.state == .active || self.game.state == .paused))
            
            Button(action: {
                self.game.board.showHint = true
                self.game.hints -= 1
            }){
                HStack{
                    Image(systemName: "lightbulb.fill")
                    Text("Hint (\(self.game.hints))")
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.orange)
                .cornerRadius(40)
            }
            .opacity(self.game.hints <= 0 || self.game.state != .active ? 0.5 : 1)
            .disabled(self.game.hints <= 0 || self.game.state != .active)
            
            Button(action: {
                self.game.state = .over
                self.presentationMode.dismiss()
            }){
                HStack{
                    Image(systemName: "chevron.left")
                    Text("Return")
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.red)
                .cornerRadius(40)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
}

/// Displays score for the game
struct ScoreView: View{
    @ObservedObject var game: Game
    
    var body: some View{
        Text("Score: \(self.game.score)")
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
            .cornerRadius(40)
    }
}

/// Displays available time for the game 
struct TimerView: View{
    @ObservedObject var gameTimer: GameTimer
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .leading, endPoint: .trailing)
                Color(UIColor.systemBackground)
                    .offset(CGSize(width: CGFloat(self.gameTimer.timeLeft)*geometry.size.width/100, height: 0))
            }
        }
        .frame(height: 4)
    }
}

/// Main game view
struct ContentView: View {
    @EnvironmentObject var game: Game
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if self.game.state == .active{
                TimerView(gameTimer: game.timer)
                BoardView(board: self.game.board)
            }else if self.game.state == .paused{
                InfoView(info: "Paused")
            }else if self.game.state == .finishedLevel{
                NextLevelView(game: game)
            }else{
                InfoView(info: "Game Over")
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Hue Connect", displayMode: .large)
        .navigationBarItems(leading: ScoreView(game: game), trailing: NavigationButtons(game: game, presentationMode: presentationMode))

    }
}
