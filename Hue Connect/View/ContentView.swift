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

struct ContentView: View {
    @State private var timeLeft: Double = 100
    @EnvironmentObject var board: Board
    
    let points: [CGPoint] = [CGPoint(x: 1, y: 1), CGPoint(x: 1, y: 6), CGPoint(x: 7, y: 6)]
    
    var timeTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    let connectionAnim = Animation.easeIn.delay(5)
    var body: some View {
        NavigationView{
            
            VStack {
                CustomSlider(value: $timeLeft, range: (0, 100), knobWidth: 0) { (modifiers) in
                    ZStack{
                        LinearGradient(gradient: Gradient(colors: [Color.red, Color.yellow, Color.green]), startPoint: .leading, endPoint: .trailing)
                        Color(UIColor.systemBackground).modifier(modifiers.barRight)
                    }
                }
                .frame(height: 4)
                .onReceive(timeTimer) { _ in
                    if(self.timeLeft > 0){
                        self.timeLeft -= 0.01

                    }
                }
                ZStack{
                    GridStack(rows:12, columns: 16){ row, col in
                        if(row == 0 || row == 11 || col == 0 || col == 15){
                            TileView(x: -1, y: -1)
                        }else{
                            TileView(x: col, y: row)
                            .gesture(TapGesture()
                                .onEnded({_ in
                                    self.board.selectTileAt(x: col, y: row)
                                }))
                        }
                    }.zIndex(1)
                    
                    TileConnectView()
                    .opacity(self.board.isConnectionShown ? 1 : 0)
                    .zIndex(2)
                }
                .navigationBarTitle("Hue Connect", displayMode: .large)
                .navigationBarItems(leading: Text("Score: 20102")
                .padding()
                .background(Color.orange)
                .cornerRadius(40)
                    ,trailing: NavigationButtons())
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
