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

class Board: ObservableObject{
    
    @Published var tileArray: [Tile] = [Tile]()
    
    let rows = 12
    let cols = 16
    
    init() {
        self.generateBoard(difficulty: 1)
    }
    
    func generateBoard(difficulty d: Int){
        
        let values: [Int] = [1,4,6,9]
        
        var chosenTiles = 0
        self.tileArray.removeAll()
        
        while chosenTiles < 192 {
            
            guard let chosenValue = values.randomElement() else {
                fatalError("Found nil while choosing a tile value")
            }
            let chosenSuit = Suit.init(rawValue: Int.random(in: 1...4))!
            
            self.tileArray.append(Tile(s: chosenSuit, value: chosenValue))
            self.tileArray.append(Tile(s: chosenSuit, value: chosenValue))
            
            chosenTiles+=2
        }
        self.tileArray.shuffle()
    }
    
    func getTileAt(x: Int, y: Int) -> Tile{
        let index = y*rows+x
        guard index < tileArray.count else {
            fatalError("Board tile array index out of bounds")
        }
        return tileArray[index]
        
    }
}
