
import Foundation
import SwiftUI

/// Tile's suits
enum Suit: Int{
    /// Empty tile
    case Empty
    /// Blue tile
    case Blue
    /// Pink tile
    case Pink
    /// Orange tile
    case Orange
    /// Green tile
    case Green
}
/// Structure representing board tile
struct Tile: Equatable{
    /// Tile's suit
    var s:  Suit
    /// Tile's tint
    var tint: Int
    
    /// Get tile color based on its suit and tint
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
        
        if(self.tint >= 1 && self.tint <= 10){
            return Color(colorName+"-\(self.tint)")
        }else{
            return Color(UIColor.systemBackground)
        }
    }
    /// Used to check if two tiles are equal
    static func == (lhs: Tile, rhs: Tile) -> Bool{
        if lhs.s == rhs.s && lhs.tint == rhs.tint {
            return true
        }
        return false
    }
}
/// Game board's representation
class Board: ObservableObject, BoardDelegate{
    //MARK: - Properties
    /// Array of tiles
    @Published var tileArray: [Tile] = [Tile]()
    /// Currently selected tile
    @Published var selectedTile: (x: Int, y: Int)?
    /// Is the hint being shown
    @Published var showHint: Bool = false
    /// Fist tile of the hint
    var hintedTile1: (x:Int, y:Int)?
    /// Second tile of the hint
    var hintedTile2: (x:Int, y:Int)?
    /// Is the tile connection being shown
    @Published var isConnectionShown: Bool = false
    /// Connection between selected tiles
    @Published var connectionPoints: [CGPoint] = [CGPoint]()
    
    /// Board's graph
    private var graph: Graph?
    /// Number of rows
    let rows = 10
    /// Number of columns
    let cols = 14
    /// Number of tiles left on the board
    var tilesLeft = 140
    /// Reference to board manager
    var manager: BoardManager?
    
    //MARK: Initializer
    init() {
        self.graph = Graph(owner: self)
        self.generateBoard(difficulty: 1)
        
        
        while !graph!.checkForMoves() {
            shuffleNotEmpty()
            graph!.resetGraph()
        }
        
    }
    //MARK: - Resetting
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
            
            guard let chosenValue = Board.getTintsArrayFor(difficulty: d).randomElement() else {
                fatalError("Found nil while choosing a tile value")
            }
            
            let chosenSuit = Suit.init(rawValue: Int.random(in: 1...4))!
            
            let t = Tile(s: chosenSuit, tint: chosenValue)
            let t1 = Tile(s: chosenSuit, tint: chosenValue)
            
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
    
    /// Get tile values for difficulties
    private static func getTintsArrayFor(difficulty d: Int) -> [Int]{
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
    //MARK: - Data
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
            return Tile(s: .Empty, tint: 1)
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
    /// Sets the new hint
    func setHintedTiles(x1: Int, y1: Int, x2: Int, y2: Int) {
        self.hintedTile1 = (x1, y1)
        self.hintedTile2 = (x2, y2)
    }
    //MARK: - Predicates
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
}
