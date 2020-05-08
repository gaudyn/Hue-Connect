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
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(color)
            .padding(2)
    }
    
    init(from tile: Tile){
        self.color = tile.getColor();
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
