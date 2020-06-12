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
            Text("HUE Connect")
                .foregroundColor(.black)
                .font(.largeTitle)
                .fontWeight(.black)
                .padding(40)
            Button(action: {
                print("hello")
            }) {
                Text("New game")
                    .font(.title)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(40)
            }
            Button(action: {
                print("hello")
            }) {
                Text("Leaderboards")
                    .font(.title)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(40)
            }
            Button(action: {
                print("hello")
            }) {
                Text("How to play")
                    .font(.title)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(40)
            }
            
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
