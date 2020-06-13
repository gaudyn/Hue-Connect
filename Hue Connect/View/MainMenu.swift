//
//  MainMenu.swift
//  Hue Connect
//
//  Created by Administrator on 08/06/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

struct MainMenu: View {
    var body: some View {
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
            Button(action: {
                print("hello")
            }) {
                Text("New game")
                    .font(.title)
                    .fontWeight(.medium)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.8))
                    .cornerRadius(40)
            }
            Button(action: {
                print("hello")
            }) {
                Text("Leaderboards")
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
            
        }.preferredColorScheme(.dark)
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}