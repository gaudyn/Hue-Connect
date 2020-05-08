//
//  Board.swift
//  Hue Connect
//
//  Created by Administrator on 08/05/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import Foundation
import SwiftUI

enum Suit: Int{
    case Empty
    
    case Blue
    case Pink
    case Orange
    case Green
}

struct Tile{
    var s:  Suit
    var value: Int
    
    func getColor() -> Color{
        
        var colorName: String
        switch self.s{
        case .Blue:
            colorName = "Blue"
        case .Pink:
            colorName = "Pink"
        case .Orange:
            colorName = "Orange"
        case .Green:
            colorName = "Green"
        default:
            return Color(UIColor.systemBackground)
        }
        
        if(self.value >= 1 && self.value <= 10){
            return Color(colorName+"-\(self.value)")
        }else{
            return Color(UIColor.systemBackground)
        }
    }
}

struct Board{
    var tileArray: [[Tile]]
    
    
}
