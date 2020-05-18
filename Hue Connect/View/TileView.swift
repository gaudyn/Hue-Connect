//
//  TileView.swift
//  Hue Connect
//
//  Created by Administrator on 06/05/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

enum ColorEnum: Int{
    case Blue
    case Pink
    case Orange
    case Green
}

struct TileView: View {
    @EnvironmentObject var board: Board
    
    var color: Color{
        get{
            return board.getTileAt(x: xPos, y: yPos).getColor()
        }
    }
    let xPos: Int
    let yPos: Int
    
    var isSelected: Bool{
        get{
            return board.isSelectedAt(x: xPos, y: yPos) || board.isHintedAt(x: xPos, y: yPos)
        }
    }
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(color)
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 5))
                    .opacity(isSelected ? 0.5 : 0))
                
        
    }
    
    init(x: Int, y: Int){
        self.xPos = x
        self.yPos = y
    }
}

/*
struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(colorType: .Orange, colorId: 9)
            .previewLayout(.fixed(width: 100, height: 150))
    }
}
*/
