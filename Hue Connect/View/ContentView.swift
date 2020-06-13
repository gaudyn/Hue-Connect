//
//  ContentView.swift
//  Hue Connect
//
//  Created by Administrator on 06/05/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

struct NavigationButtons: View{
    
    @EnvironmentObject var board: Board
    
    var body: some View {
        HStack{
                    Button(action: {
                        self.board.showHint = true
                    }){
                        HStack{
                            Image(systemName: "lightbulb.fill")
                            Text("Hint")
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
                        self.board.generateBoard(difficulty: 1)
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
    
    var body: some View{
        Text("Score: 20102")
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
            .cornerRadius(40)
    }
}

struct TimerView: View{
    
    @State private var timeLeft: Double = 100
    var timeTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View{
        CustomSlider(value: $timeLeft, range: (0, 100), knobWidth: 0) { (modifiers) in
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .leading, endPoint: .trailing)
                Color(UIColor.systemBackground).modifier(modifiers.barRight)
            }
        }
        .frame(height: 4)
        .onReceive(timeTimer) { _ in
            if(self.timeLeft > 0){
                self.timeLeft -= 0.01

            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var board: Board
    
    var body: some View {
        NavigationView{
            VStack {
                TimerView()
                BoardView()
                .navigationBarTitle("Hue Connect", displayMode: .large)
                .navigationBarItems(leading: ScoreView(), trailing: NavigationButtons())
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(PreviewLayout.fixed(width: 2224, height: 1668))
    }
}
