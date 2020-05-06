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
        VStack(alignment: .leading){
            ForEach(0 ..< rows, id: \.self){ row in
                HStack(){
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
                        print("hint")
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
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
