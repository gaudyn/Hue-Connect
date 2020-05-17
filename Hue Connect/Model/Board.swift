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
            print("Shuffling")
            shuffleNotEmpty()
            graph!.resetGraph()
        }
        
    }
    
    func generateBoard(difficulty d: Int){

        var chosenTiles = 0
        tilesLeft = rows*cols
        self.tileArray.removeAll()
        
        while chosenTiles < 10*14 {
            
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
        
    }
    
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
    
    private struct Graph{
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
            var tile: Tile
            var curves: Int
        }
        static let height = 12
        static let width = 16
        
        var G = Array(repeating: Array(repeating: Node(visit: .NotVisited, tile: Tile(s: .Empty, value: 100), curves: 0), count: width), count: height)
        var nextIter = [(x: Int, y: Int)]()
        
        let owner: Board
        init(owner: Board) {
            self.owner = owner
            for i in 1..<11{
                for j in 1..<15{
                    G[i][j].tile = owner.getTileAt(x: j, y: i)
                }
            }
        }
        
        mutating func checkForMoves() -> Bool{
            for i in 1..<11{
                for j in 1..<15{
                    if(G[i][j].tile.s != .Empty && IDDFS(startX: j, startY: i, goalX: nil, goalY: nil)){
                        return true
                    }
                }
            }
            return false
        }
        
        mutating func isMoveValid(fromX: Int, fromY: Int, toX: Int, toY: Int) -> Bool{
            if(IDDFS(startX: fromX, startY: fromY, goalX: toX, goalY: toY)){
                return true
            }else{
                return false
            }
        }
        
        func traceMove(fromX: Int, fromY: Int, toX: Int, toY: Int) -> [CGPoint]{
            var myX = toX
            var myY = toY
            var points = [CGPoint(x: myX, y: myY)]
            
            while(myX != fromX || myY != fromY){
                print("PĘTLA ROBI BRRR")
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
        
        mutating func resetGraph(){
            for i in 0..<12{
                for j in 0..<16{
                    if i > 0 && i < 11 && j > 0 && j < 15{
                        G[i][j].tile = owner.getTileAt(x: j, y: i)
                    }else{
                        G[i][j].tile.s = .Empty
                    }
                    G[i][j].visit = .NotVisited
                    G[i][j].curves = 0
                }
            }
        }
        
        let maxDepth = 1
        mutating func IDDFS(startX: Int, startY: Int, goalX: Int?, goalY: Int?) -> Bool{
            resetGraph()
            for curves in 0...2{
                G[startY][startX].visit = .Start
                G[startY][startX].curves = 0
                if(DLS(startX: startX, startY: startY, nodeX: startX, nodeY: startY, goal: G[startY][startX].tile, goalX: goalX, goalY: goalY, curves: curves)){
                    return true
                }
                resetGraph()
            }
            return false
        }
        
        mutating func DLS(startX: Int, startY: Int, nodeX: Int, nodeY: Int, goal: Tile, goalX: Int?, goalY: Int?, curves: Int) -> Bool{
            
            
            if let gx = goalX, let gy = goalY{
                if nodeX == gx, nodeY == gy{
                    return true
                }
            }else if G[nodeY][nodeX].tile == goal && (nodeX != startX || nodeY != startY){
                print(startX, startY, nodeX, nodeY)
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
                
                if moveX > -1 && moveX < Board.Graph.width && moveY > -1 && moveY < Board.Graph.height{
                    // Check if tile has been visited
                    if G[moveY][moveX].visit == .NotVisited{
                        let saveCurves = G[moveY][moveX].curves
                        G[moveY][moveX].curves = curves
                        G[moveY][moveX].visit = move.2
                        //Check if this moves curves the line
                        if freeMove == (0,0) || (move.0 == freeMove.0 && move.1 == freeMove.1) {
                            //Line doesn't curve
                            if G[moveY][moveX].tile.s == .Empty {
                                //Empty tile -> run dls from there
                                if DLS(startX: startX, startY: startY, nodeX: moveX, nodeY: moveY, goal: goal, goalX: goalX, goalY: goalY, curves: curves) {
                                    return true
                                }
                            }else if G[moveY][moveX].tile == goal{
                                if DLS(startX: startX, startY: startY, nodeX: moveX, nodeY: moveY, goal: goal, goalX: goalX, goalY: goalY, curves: -1) {
                                    return true
                                }
                            }
                        }else{
                            //Line curves
                            if G[moveY][moveX].tile.s == .Empty {
                                //Empty tile -> run dls from there
                                if DLS(startX: startX, startY: startY, nodeX: moveX, nodeY: moveY, goal: goal, goalX: goalX, goalY: goalY, curves: curves-1) {
                                    return true
                                }
                            }else if G[moveY][moveX].tile == goal && curves > 0{
                                if DLS(startX: startX, startY: startY, nodeX: moveX, nodeY: moveY, goal: goal, goalX: goalX, goalY: goalY, curves: -1) {
                                    return true
                                }
                            }
                        }
                        G[moveY][moveX].visit = .NotVisited
                        G[moveY][moveX].curves = saveCurves
                    }
                }
            }
            return false
        }
    }
}
