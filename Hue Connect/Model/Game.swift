//
//  Game.swift
//  Hue Connect
//
//  Created by Administrator on 13/06/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import Foundation
import Combine

protocol Scoring {
    func increaseScore()
}

class Game: Scoring, ObservableObject{
    @Published var board: Board
    @Published var score: Int
    @Published var hints: Int
    @Published var timeLeft: Double
    
    var timer = Timer()
    
    private var currentDifficulty: Int
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        board = Board()
        score = 0
        hints = 6
        currentDifficulty = 1
        timeLeft = 100
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.fireTimer()
        })
        
        anyCancellable = board.objectWillChange.sink{ _ in
            self.objectWillChange.send()
        }
        
        
        board.scoreDelegate = self
    }
    
    func resetGame(){
        score = 0
        timeLeft = 100
        hints = 6
        currentDifficulty = 1
        board.generateBoard(difficulty: 1)
    }
    
    func fireTimer(){
        if(timeLeft > 0){
            timeLeft -= 0.1*Double(currentDifficulty)
        }
    }
    
    func increaseScore() {
        score += 10*Int(pow(Double(2),Double(currentDifficulty)))
        
    }
    
}
