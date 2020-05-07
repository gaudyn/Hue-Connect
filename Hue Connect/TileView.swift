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
    
    init(colorType: ColorEnum, colorId: Int){
        var colorName: String
        switch colorType{
        case .Blue:
            colorName = "Blue"
        case .Pink:
            colorName = "Pink"
        case .Orange:
            colorName = "Orange"
        case .Green:
            colorName = "Green"
        }
        if(colorId >= 1 && colorId <= 10){
            color = Color(colorName+"-\(colorId)")
        }else{
            color = Color(UIColor.systemBackground)
        }
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(colorType: .Orange, colorId: 9)
            .previewLayout(.fixed(width: 100, height: 150))
    }
}
