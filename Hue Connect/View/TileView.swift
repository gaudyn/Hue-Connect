//
//  TileView.swift
//  Hue Connect
//
//  Created by Administrator on 06/05/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI
/// Tile view based on color and selection
struct TileView: View {
    var color: Color
    var isSelected: Bool
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(color)
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 5))
                    .opacity(isSelected ? 0.9 : 0))
                
        
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
