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
    
    @Published var showHint: Bool = false
    var hintedTile1: (x:Int, y:Int)?
    var hintedTile2: (x:Int, y:Int)?
    
    @Published var isConnectionShown: Bool = false
    @Published var connectionPoints: [CGPoint] = [CGPoint]()
    
    
    
    private var graph: Graph?
    
    let rows = 10
    let cols = 14
    var tilesLeft = 140
    
    init() {
        self.generateBoard(difficulty: 1)
        self.graph = Graph(owner: self)
        
        
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
        while !(graph?.checkForMoves() ?? true) {
            shuffleNotEmpty()
            graph?.resetGraph()
        }
    }
    
    /// Get tile values for difficulties
    private static func getValuesArrayFor(difficulty d: Int) -> [Int]{
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
                    
                    while(!graph!.checkForMoves() && tilesLeft > 0){
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
        let index = (y-1)*cols+(x-1)
        if index < 0 || index >= rows*cols{
            return Tile(s: .Empty, value: 1)
        }
        return tileArray[index]
    }
    /// Changes tile at x,y to an empty tile
    private func removeTileAt(x: Int, y: Int){
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
/// Graph struct providing graph searches for board
fileprivate struct Graph{
    struct Node{
        enum visFrom: Int{
            case NotVisited
            case Start
            case Top
            case Right
            case Left
            case Bottom
        }
        var visit: visFrom
    }
    static let height = 12
    static let width = 16
    
    var G = Array(repeating: Array(repeating: Node(visit: .NotVisited), count: width), count: height)
    var nextIter = [(x: Int, y: Int)]()
    
    let owner: Board
    init(owner: Board) {
        self.owner = owner
    }
    
    /**
    Checks whole board for available moves
     
    - returns: `true` if any moves exist
    */
    mutating func checkForMoves() -> Bool{
        for i in 1..<11{
            for j in 1..<15{
                if(owner.getTileAt(x: i, y: j).s != .Empty && IDDFS(startX: j, startY: i, goalX: nil, goalY: nil)){
                    return true
                }
            }
        }
        return false
    }
    
    /**
    Checks if there exists a move from start to goal

    - parameters:
        - fromX: Starting point's X coordinate.
        - fromY: Starting point's Y coordinate.
        - toX: Goal point's X coordinate.
        - toY: Goal point's Y coordinate.
     
    - returns: `true` if move exists
    */
    mutating func isMoveValid(fromX: Int, fromY: Int, toX: Int, toY: Int) -> Bool{
        return IDDFS(startX: fromX, startY: fromY, goalX: toX, goalY: toY)
    }
    /**
    Creates a path from start to goal
     - precondition:
     Requires a vaild path from **start** to **goal**

    - parameters:
        - fromX: Starting point's X coordinate.
        - fromY: Starting point's Y coordinate.
        - toX: Goal point's X coordinate.
        - toY: Goal point's Y coordinate.
     
    - returns: Array of passed points.
    */
    func traceMove(fromX: Int, fromY: Int, toX: Int, toY: Int) -> [CGPoint]{
        var myX = toX
        var myY = toY
        var points = [CGPoint(x: myX, y: myY)]
        
        while(myX != fromX || myY != fromY){
            switch G[myY][myX].visit {
            case .Bottom:
                myY-=1
            case .Top:
                myY+=1
            case .Right:
                myX+=1
            case .Left:
                myX-=1
            default:
                fatalError("Moved to not visited tile! \(myX), \(myY)")
            }
            points.append(CGPoint(x: myX, y: myY))
        }
        points.append(CGPoint(x: fromX, y: fromY))
        return points
    }
    /// Resets graph data using owner tiles
    mutating func resetGraph(){
        for i in 0..<12{
            for j in 0..<16{
                G[i][j].visit = .NotVisited
            }
        }
    }
    
    /**
    Searches graph iteratively

    - parameters:
        - startX: Starting point's X coordinate.
        - startY: Starting point's Y coordinate.
        - goalX: (optional) Goal point's X coordinate.
        - goalY: (optional) Goal point's Y coordinate.
     
    - returns: `true` if there are available moves from the tile (1) or if you can reach the goal from the starting position (2).

     # Usages: #
     1. To check existing moves from a starting tile leave goal's position as `nil`
     2. To find a route from starting tile to goal provide goal's position
    */
    mutating func IDDFS(startX: Int, startY: Int, goalX: Int?, goalY: Int?) -> Bool{
        resetGraph()
        for curves in 0...2{
            G[startY][startX].visit = .Start
            if(DLS(startX: startX, startY: startY, nodeX: startX, nodeY: startY,
                   goal: owner.getTileAt(x: startX, y: startY), goalX: goalX, goalY: goalY, curves: curves)){
                return true
            }
            resetGraph()
        }
        return false
    }
    
    /**
    Searches graph using DFS

    - parameters:
        - startX: Starting point's X coordinate.
        - startY: Starting point's Y coordinate.
        - nodeX: Current point's X coordinate.
        - nodeY: Current point's Y coordinate.
        - goal: Goal's tile type.
        - goalX: (optional) Goal point's X coordinate.
        - goalY: (optional) Goal point's Y coordinate.
        - curves: Available line breaks.
     
    - returns: `true` if there are available moves from the tile (1) or if you can reach the goal from the starting position (2).

     # Usage: #
     1. To check existing moves from a starting tile leave goal's position as `nil`
     2. To find a route from starting tile to goal provide goal's position
    */
    mutating func DLS(startX: Int, startY: Int, nodeX: Int, nodeY: Int, goal: Tile, goalX: Int?, goalY: Int?, curves: Int) -> Bool{
        
        
        if let gx = goalX, let gy = goalY{
            if nodeX == gx, nodeY == gy{
                return true
            }
        }else if owner.getTileAt(x: nodeX, y: nodeY) == goal && (nodeX != startX || nodeY != startY){
            owner.hintedTile1 = (startX, startY)
            owner.hintedTile2 = (nodeX, nodeY)
            return true
        }
        
        if curves < 0 {
            return false
        }
        
        let freeMove: (Int, Int)
        
        switch G[nodeY][nodeX].visit{
        case .Top:
            freeMove = ( 0,-1)
        case .Bottom:
            freeMove = ( 0, 1)
        case .Right:
            freeMove = (-1, 0)
        case .Left:
            freeMove = ( 1, 0)
        case .Start:
            freeMove = ( 0, 0)
        case .NotVisited:
            fatalError("DFS from unvisited node \(nodeX), \(nodeY)")
        }
        
        let possibleMoves = [(0,1, Node.visFrom.Bottom),(1,0, Node.visFrom.Left),(0,-1, Node.visFrom.Top),(-1,0, Node.visFrom.Right)]
        for move in possibleMoves{
            
            let moveX = nodeX+move.0
            let moveY = nodeY+move.1
            
            if moveX > -1 && moveX < Graph.width && moveY > -1 && moveY < Graph.height{
                // Check if tile has been visited
                if G[moveY][moveX].visit == .NotVisited{
                    G[moveY][moveX].visit = move.2
                    
                    //Check if this moves curves the line
                    if freeMove == (0,0) || (move.0 == freeMove.0 && move.1 == freeMove.1) {
                        //Line doesn't curve
                        if owner.getTileAt(x: moveX, y: moveY).s == .Empty {
                            //Empty tile -> run dls from there
                            if DLS(startX: startX, startY: startY, nodeX: moveX, nodeY: moveY, goal: goal, goalX: goalX, goalY: goalY, curves: curves) {
                                return true
                            }
                        }else if owner.getTileAt(x: moveX, y: moveY) == goal{
                            if DLS(startX: startX, startY: startY, nodeX: moveX, nodeY: moveY, goal: goal, goalX: goalX, goalY: goalY, curves: -1) {
                                return true
                            }
                        }
                    }else{
                        //Line curves
                        if owner.getTileAt(x: moveX, y: moveY).s == .Empty {
                            //Empty tile -> run dls from there
                            if DLS(startX: startX, startY: startY, nodeX: moveX, nodeY: moveY, goal: goal, goalX: goalX, goalY: goalY, curves: curves-1) {
                                return true
                            }
                        }else if owner.getTileAt(x: moveX, y: moveY) == goal && curves > 0{
                            if DLS(startX: startX, startY: startY, nodeX: moveX, nodeY: moveY, goal: goal, goalX: goalX, goalY: goalY, curves: -1) {
                                return true
                            }
                        }
                    }
                    G[moveY][moveX].visit = .NotVisited
                }
            }
        }
        return false
    }
}
