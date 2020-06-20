//
//  GameTimer.swift
//  Hue Connect
//
//  Created by Administrator on 20/06/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import Foundation

protocol GameDelegate {
    var dTime: Double { get }
    func setGameOver()
}

class GameTimer: ObservableObject{
    
    @Published var timeLeft: Double
    private let maxTime: Double = 100
    private var timer: Timer?
    
    var delegate: GameDelegate?
    
    init() {
        self.timeLeft = maxTime
    }
    
    //MARK: - Timer methods
    func start(){
        guard timer == nil else {
            return
        }
        self.timer = Timer(timeInterval: 0.01, repeats: true){ _ in
            self.fireTimer()
        }
        RunLoop.main.add(self.timer!, forMode: .common)
        
    }
    
    func stop(){
        guard timer != nil else {
            return
        }
        timer?.invalidate()
        timer = nil
    }
    
    func reset(){
        timeLeft = maxTime
        start()
    }
    
    func fireTimer(){
        print(timeLeft)
        if timeLeft > 0 {
            timeLeft -= delegate?.dTime ?? 0.001
        } else {
            stop()
            delegate?.setGameOver()
        }
    }
}
