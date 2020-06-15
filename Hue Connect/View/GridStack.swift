//
//  GridStack.swift
//  Hue Connect
//
//  Created by Administrator on 11/05/2020.
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
    
    /**
    Creates a grid view

     - parameters:
        - rows: Number of rows of grid.
        - columns: Number of columns of grid.
        - content: Function returning content for (x,y) cell in the grid.
    */
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content){
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
