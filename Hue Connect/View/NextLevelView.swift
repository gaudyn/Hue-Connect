//
//  NextLevelView.swift
//  Hue Connect
//
//  Created by Administrator on 14/06/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

struct NextLevelView: View {
    @ObservedObject var game: Game
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
