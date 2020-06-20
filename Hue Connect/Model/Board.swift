
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
    
    /// Get tile color based on its suit and value
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
    
    @Published var showHint: Bool = false
    var hintedTile1: (x:Int, y:Int)?
    var hintedTile2: (x:Int, y:Int)?
    
    @Published var isConnectionShown: Bool = false
    @Published var connectionPoints: [CGPoint] = [CGPoint]()
    
    
    
    private var graph: Graph?
    
    let rows = 10
    let cols = 14
    var tilesLeft = 140
    var manager: BoardManager?
    
    init() {
        self.graph = Graph(owner: self)
        self.generateBoard(difficulty: 1)
        
        
        while !graph!.checkForMoves() {
            shuffleNotEmpty()
            graph!.resetGraph()
        }
        
    }
    /// Generates a new board with set difficulty level
    func generateBoard(difficulty d: Int){

        var chosenTiles = 0
        showHint = false
        selectedTile = nil
        hintedTile1 = nil
        hintedTile2 = nil
        
        tilesLeft = rows*cols
        self.tileArray.removeAll()
        
        while chosenTiles < rows*cols {
            
            guard let chosenValue = Board.getValuesArrayFor(difficulty: d).randomElement() else {
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
        while !(graph!.checkForMoves()) {
            shuffleNotEmpty()
            graph!.resetGraph()
        }
    }
    
    /// Get tile values for difficulties
    private static func getValuesArrayFor(difficulty d: Int) -> [Int]{
        switch d{
        case 10..<100:
            return [1,2,3,4,5,6,7,8,9]
        case 7, 8, 9:
            return [1,3,4,5,6,7,8,9]
        case 4, 5, 6:
            return [1,4,5,6,7,8,9]
        case 2, 3:
            return [1,3,5,7,9]
        default:
            return [1,4,6,9]
        }
    }
    
    /**
    Selects tile at x,y

     # Notes: #
     1. If a tile has been selected before, checks if connecting new and old selection is a valid move
    */
    func selectTileAt(x: Int, y: Int){
        if(getTileAt(x: x, y: y).s == .Empty || selectedTile != nil && (selectedTile?.x == x && selectedTile?.y == y)){
            return
        }
        
        if let selectedX = selectedTile?.x,
            let selectedY = selectedTile?.y{
            
            if(getTileAt(x: x, y: y) == getTileAt(x: selectedX, y: selectedY)){
                if(graph!.isMoveValid(fromX: x, fromY: y, toX: selectedX, toY: selectedY)){
                    connectionPoints = graph!.traceMove(fromX: x, fromY: y, toX: selectedX, toY: selectedY)
                    isConnectionShown = true
                    
                    removeTileAt(x: x, y: y)
                    removeTileAt(x: selectedX, y: selectedY)
                    selectedTile = nil
                    
                    hintedTile1 = nil
                    hintedTile2 = nil
                    
                    showHint = false
                    
                    graph!.resetGraph()
                    tilesLeft-=2
                    manager?.increaseScore()
                    
                    if(tilesLeft <= 0){
                        manager?.finishLevel()
                        return
                    }
                    
                    while(!graph!.checkForMoves()){
                        shuffleNotEmpty()
                        graph!.resetGraph()
                    }
                    
                    return
                }
            }
        }
        selectedTile = (x: x, y: y)
    }
    /// Returns tile at x,y
    func getTileAt(x: Int, y: Int) -> Tile{
        if x <= 0 || x > cols || y <= 0 || y > rows{
            return Tile(s: .Empty, value: 1)
        }
        let index = (y-1)*cols+(x-1)
        return tileArray[index]
    }
    /// Changes tile at x,y to an empty tile
    private func removeTileAt(x: Int, y: Int){
        if x <= 0 || x > cols || y <= 0 || y > rows{
            return
        }
        let index = (y-1)*cols+(x-1)
        tileArray[index].s = .Empty
    }
    /// Returns `true` if tile at x,y is selected by player
    func isSelectedAt(x: Int, y:Int) -> Bool{
        if selectedTile?.x == x && selectedTile?.y == y{
            return true
        }
        return false
    }
    /// Returns `true` if tile at x,y is a hint
    func isHintedAt(x: Int, y:Int) -> Bool{
        if !showHint{
            return false
        }
        if (hintedTile1?.x == x && hintedTile1?.y == y) ||
           (hintedTile2?.x == x && hintedTile2?.y == y){
            return true
        }
        return false
    }
    /// Shuffles not empty board tiles without changing their position with empty tiles
    func shuffleNotEmpty(){
        let notEmptyTiles = tileArray.enumerated().filter { (index, tile) -> Bool in
            return tile.s == .Empty ? false : true
        }
        var notEmptyIndexes = notEmptyTiles.map { (index, tile) in
            return index
        }
        notEmptyIndexes.shuffle()
        
        for i in 0..<notEmptyIndexes.count{
            tileArray[notEmptyIndexes[i]] = notEmptyTiles[i].element
        }
    }
}
extension Board: BoardDelegate{
    func setHintedTiles(x1: Int, y1: Int, x2: Int, y2: Int) {
        self.hintedTile1 = (x1, y1)
        self.hintedTile2 = (x2, y2)
    }
}
