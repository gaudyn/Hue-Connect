//
//  MainMenu.swift
//  Hue Connect
//
//  Created by Administrator on 08/06/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

/// Hue Connect main menu
struct MainMenu: View {

    @EnvironmentObject var game: Game
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 8){
                Text("HUE")
                    .font(.system(size: 100, weight: .black, design: .rounded))
                    .overlay(LinearGradient(gradient: Gradient(colors: [.red, .red, .orange, .yellow, .green, .blue, .purple, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .mask(Text("HUE")
                        .font(.system(size: 100, weight: .black, design: .rounded))
                        .scaledToFill())
                Text("Connect")
                    .foregroundColor(.white)
                    .font(.system(size: 50, weight: .regular, design: .rounded))
                NavigationLink(destination: ContentView().environmentObject(game)){
                    Text("New game")
                    .font(.title)
                    .fontWeight(.medium)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.8))
                    .cornerRadius(40)
                }
                .simultaneousGesture(TapGesture().onEnded{
                    self.game.resetGame()
                })
                NavigationLink(destination: HighscoresView()){
                    Text("Highscores")
                        .font(.title)
                        .fontWeight(.medium)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.8))
                        .cornerRadius(40)
                }
                Button(action: {
                    print("hello")
                }) {
                    Text("How to play")
                        .font(.title)
                        .fontWeight(.medium)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                            .opacity(0.8))
                        .cornerRadius(40)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
