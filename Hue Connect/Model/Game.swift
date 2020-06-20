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

class Game: ObservableObject{
    @Published var board: Board
    @Published var score: Int
    @Published var hints: Int
    @Published var timer: GameTimer
    @Published var state: GameState
    
    private var currentDifficulty: Int
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        board = Board()
        score = 0
        hints = 6
        currentDifficulty = 1
        timer = GameTimer()
        state = .active
        
        anyCancellable = board.objectWillChange.sink{ _ in
            self.objectWillChange.send()
        }
        
        timer.delegate = self
        board.manager = self
    }
    /// Reset the game to the beginning
    func resetGame(){
        score = 0
        timer.reset()
        hints = 6
        currentDifficulty = 1
        board.generateBoard(difficulty: 1)
        state = .active
    }
    /// Proceed to the next level
    func nextLevel(){
        state = .active
        timer.reset()
        currentDifficulty += 1
        hints+=2
        board.generateBoard(difficulty: currentDifficulty)
    }
    
    
}
extension Game: BoardManager{
    /// Increase game score based on game diificulty level
    func increaseScore() {
        score += 10*Int(pow(Double(2),Double(currentDifficulty)))
    }
    /// Change the game's state to finished level and add bonus points for time
    func finishLevel(){
        state = .finishedLevel
        score += Int(timer.timeLeft*1000)*currentDifficulty
    }
}

extension Game: GameDelegate{
    /// Returns the delta t value based on difficulty
    var dTime: Double{
        get{
            0.001*Double(currentDifficulty)
        }
    }
    
    /// Finish the game and update highscores
    func setGameOver(){
        state = .over
        ScoreManager.shared.addScore(self.score)
    }
    
    func pause(){
        self.state = .paused
        self.timer.stop()
    }
    
    func unpause(){
        self.state = .active
        self.timer.start()
    }
}
