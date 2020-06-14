//
//  Game.swift
//  Hue Connect
//
//  Created by Administrator on 13/06/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import Foundation
import Combine

protocol BoardManager {
    func increaseScore()
    func finishLevel()
}

enum GameState{
    case active
    case paused
    case finishedLevel
    case over
}

class Game: BoardManager, ObservableObject{
    @Published var board: Board
    @Published var score: Int
    @Published var hints: Int
    @Published var timeLeft: Double
    @Published var state: GameState
    
    var dTime: Double{
        get{
            0.001*Double(currentDifficulty)
        }
    }
    
    private var currentDifficulty: Int
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        board = Board()
        score = 0
        hints = 6
        currentDifficulty = 1
        timeLeft = 100
        state = .active
        
        anyCancellable = board.objectWillChange.sink{ _ in
            self.objectWillChange.send()
        }
        
        board.manager = self
    }
    
    func resetGame(){
        score = 0
        timeLeft = 100
        hints = 6
        currentDifficulty = 1
        board.generateBoard(difficulty: 1)
        state = .active
    }
    
    func increaseScore() {
        score += 10*Int(pow(Double(2),Double(currentDifficulty)))
    }
    func finishLevel(){
        state = .finishedLevel
    }
    func nextLevel(){
        state = .active
        timeLeft = 100
        currentDifficulty += 1
        hints+=2
        board.generateBoard(difficulty: currentDifficulty)
    }
    
}
