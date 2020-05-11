//
//  ContentView.swift
//  Hue Connect
//
//  Created by Administrator on 06/05/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

struct GridStack<Content: View>: View{
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View{
        VStack(alignment: .leading, spacing: 0){
            ForEach(0 ..< rows, id: \.self){ row in
                HStack(spacing: 0){
                    ForEach(0 ..< self.columns, id: \.self){ column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content){
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct NavigationButtons: View{
    
    var board: Board
    
    init(board: Board) {
        self.board = board
    }
    
    var body: some View {
        HStack{
                    Button(action: {
                        print("hint")
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
                        print("hint")
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
    @ObservedObject private var board = Board()
    
    var timeTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
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
                            TileView(from: Tile(s: .Empty, value: 0))
                        }else{
                            TileView(from: self.board.getTileAt(x: col, y: row))
                        }
                    }
                    TileConnectView(tileCoords: [CGPoint(x: 1, y: 1), CGPoint(x: 1, y: 6), CGPoint(x: 7, y: 6)])
                }
                .navigationBarTitle("Hue Connect", displayMode: .large)
                .navigationBarItems(trailing: NavigationButtons(board: board))
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
