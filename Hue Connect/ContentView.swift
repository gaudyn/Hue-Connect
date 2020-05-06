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
