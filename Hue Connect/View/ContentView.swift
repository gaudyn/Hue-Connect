//
//  ContentView.swift
//  Hue Connect
//
//  Created by Administrator on 06/05/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

struct NavigationButtons: View{
    
    @EnvironmentObject var game: Game
    
    var body: some View {
        HStack{
                    Button(action: {
                        self.game.board.showHint = true
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
                    Button(action: {
                        print("PAUSE")
                    }){
                        HStack{
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .cornerRadius(40)
                    }
                    Button(action: {
                        self.game.resetGame()
                    }){
                        HStack{
                            Image(systemName: "gobackward")
                            Text("Reset")
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

struct ScoreView: View{
    @EnvironmentObject var game: Game
    
    var body: some View{
        Text("Score: \(self.game.score)")
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
            .cornerRadius(40)
    }
}

struct TimerView: View{
    @EnvironmentObject var game: Game
    
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .leading, endPoint: .trailing)
                Color(UIColor.systemBackground)
                    .offset(CGSize(width: CGFloat(self.game.timeLeft)*geometry.size.width/100, height: 0))
            }
        }
        .frame(height: 4)
    }
}

struct ContentView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        NavigationView{
            VStack {
                TimerView()
                BoardView(board: self.game.board)
                .navigationBarTitle("Hue Connect", displayMode: .large)
                .navigationBarItems(leading: ScoreView(), trailing: NavigationButtons())
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(PreviewLayout.fixed(width: 2224, height: 1668))
    }
}
