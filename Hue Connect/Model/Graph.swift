
import Foundation
import CoreGraphics

/// Board delegate used by graph object
protocol BoardDelegate {
    /// Get a tile at position from board
    /// - parameter x: X coordinate
    /// - parameter y: Y coordinate
    /// - returns: Tile at (x,y) position in the board
    func getTileAt(x: Int, y: Int) -> Tile
    /// Sets possible hint in the board
    /// - parameter x1: First tile's X coordinate
    /// - parameter y1: First tile's Y coordinate
    /// - parameter x2: Second tile's X coordinate
    /// - parameter y2: Second tile's Y coordinate
    func setHintedTiles(x1: Int, y1: Int, x2: Int, y2: Int)
}

/// Rectangular graph structure providing graph searches for board
class Graph{
    /// Structure representing graph's node
    struct Node{
        /// Possible visited states
        enum visFrom: Int{
            /// The node has not been visited
            case NotVisited
            /// The node is the starting node in the graph
            case Start
            /// The node has been visited from the top
            case Top
            /// The node has been visited from the right
            case Right
            /// The node has been visited from the left
            case Left
            /// The node has been visited from the bottom
            case Bottom
        }
        /// Node's visited state
        var visit: visFrom
    }
    // MARK: - Properties
    /// Graph height
    static let height = 12
    /// Graph width
    static let width = 16
    
    /// The node array representing the graph
    var G = Array(repeating: Array(repeating: Node(visit: .NotVisited), count: width), count: height)
    
    /// The board delegate
    let owner: BoardDelegate
    
    // MARK: - Initializers
    /// Creates a graph
    /// - parameter owner: Game board to reference
    init(owner: BoardDelegate){
        self.owner = owner
    }
    
    // MARK: - Board comunication
    /**
    Checks whole board for available moves
     
    - returns: `true` if any moves exist
    */
    func checkForMoves() -> Bool{
        for i in 1..<11{
            for j in 1..<15{
                if(owner.getTileAt(x: j, y: i).s != .Empty && IDDFS(startX: j, startY: i, goalX: nil, goalY: nil)){
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
    func isMoveValid(fromX: Int, fromY: Int, toX: Int, toY: Int) -> Bool{
        return IDDFS(startX: fromX, startY: fromY, goalX: toX, goalY: toY)
    }
    /**
    Creates a path from start to goal
    - precondition: Requires a vaild path from **start** to **goal**

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
    func resetGraph(){
        for i in 0..<12{
            for j in 0..<16{
                G[i][j].visit = .NotVisited
            }
        }
    }
    // MARK: - Graph searching
    /**
    Searches graph iteratively
    - Note:
     Possible usage:
     1. To check existing moves from a starting tile leave goal's position as `nil`
     2. To find a route from starting tile to goal provide goal's position
     
    - parameters:
        - startX: Starting point's X coordinate.
        - startY: Starting point's Y coordinate.
        - goalX: (optional) Goal point's X coordinate.
        - goalY: (optional) Goal point's Y coordinate.
     
    - returns: `true` if there are available moves from the tile (1) or if you can reach the goal from the starting position (2).
    - postcondition: If a valid path has been found the graph isn't reseted
     
    */
    private func IDDFS(startX: Int, startY: Int, goalX: Int?, goalY: Int?) -> Bool{
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

    - Note:
     Possible usage:
     1. To check existing moves from a starting tile leave goal's position as `nil`
     2. To find a route from starting tile to goal provide goal's position
    */
    private func DLS(startX: Int, startY: Int, nodeX: Int, nodeY: Int, goal: Tile, goalX: Int?, goalY: Int?, curves: Int) -> Bool{
        
        
        if let gx = goalX, let gy = goalY{
            if nodeX == gx, nodeY == gy{
                return true
            }
        }else if owner.getTileAt(x: nodeX, y: nodeY) == goal && (nodeX != startX || nodeY != startY){
            owner.setHintedTiles(x1: startX, y1: startY, x2: nodeX, y2: nodeY)
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
