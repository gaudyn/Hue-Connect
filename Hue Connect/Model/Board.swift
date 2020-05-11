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

struct Tile: Equatable{
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
    
    static func == (lhs: Tile, rhs: Tile) -> Bool{
        if lhs.s == rhs.s && lhs.value == rhs.value {
            return true
        }
        return false
    }
}

class Board: ObservableObject{
    
    @Published var tileArray: [Tile] = [Tile]()
    @Published var selectedTile: (x: Int, y: Int)?
    
    
    let rows = 10
    let cols = 14
    
    init() {
        self.generateBoard(difficulty: 1)
    }
    
    func generateBoard(difficulty d: Int){

        var chosenTiles = 0
        self.tileArray.removeAll()
        
        while chosenTiles < 10*14 {
            
            guard let chosenValue = getValuesArrayFor(difficulty: d).randomElement() else {
                fatalError("Found nil while choosing a tile value")
            }
            let chosenSuit = Suit.init(rawValue: Int.random(in: 1...4))!
            
            let t = Tile(s: chosenSuit, value: chosenValue)
            let t1 = Tile(s: chosenSuit, value: chosenValue)
            
            self.tileArray.append(t)
            self.tileArray.append(t1)
            
            chosenTiles+=2
        }
        self.tileArray.shuffle()
    }
    
    private func getValuesArrayFor(difficulty d: Int) -> [Int]{
        switch d{
        case 5:
            return [1,2,3,4,5,6,7,8,9]
        case 4:
            return [1,3,4,5,6,7,8,9]
        case 3:
            return [1,4,5,6,7,8,9]
        case 2:
            return [1,3,5,7,9]
        default:
            return [1,4,6,9]
        }
    }
    
    func selectTileAt(x: Int, y: Int){
        if(getTileAt(x: x, y: y).s == .Empty || selectedTile != nil && (selectedTile?.x == x && selectedTile?.y == y)){
            return
        }
        
        if let selectedX = selectedTile?.x,
            let selectedY = selectedTile?.y{
            
            if(getTileAt(x: x, y: y) == getTileAt(x: selectedX, y: selectedY)){
                removeTileAt(x: x, y: y)
                removeTileAt(x: selectedX, y: selectedY)
                selectedTile = nil
                return
            }
        }
        selectedTile = (x: x, y: y)
    }
    
    func getTileAt(x: Int, y: Int) -> Tile{
        let index = (y-1)*cols+(x-1)
        if index < 0 || index > 10*14{
            return Tile(s: .Empty, value: 1)
        }
        return tileArray[index]
    }
    private func removeTileAt(x: Int, y: Int){
        let index = (y-1)*cols+(x-1)
        tileArray[index].s = .Empty
    }
    
    func isSelectedAt(x: Int, y:Int) -> Bool{
        if(selectedTile?.x == x && selectedTile?.y == y){
            return true
        }
        return false
    }
}
