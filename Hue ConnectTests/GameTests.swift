//
//  GameTests.swift
//  Hue ConnectTests
//
//  Created by Administrator on 16/06/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import XCTest
@testable import Hue_Connect

class GameTests: XCTestCase {

    var game = Game()

    func testReset() {
        game.resetGame()
        
        XCTAssertEqual(game.score, 0)
        XCTAssertEqual(game.state, .active)
        XCTAssertEqual(game.hints, 6)
        XCTAssertEqual(game.timeLeft, 100)
    }
    
    func testFinishLevel() {
        game.finishLevel()
        
        XCTAssertEqual(game.state, .finishedLevel)
    }
    
    func testNextLevel() {
        let dt = game.dTime
        
        game.nextLevel()
        
        XCTAssertEqual(game.state, .active)
        XCTAssertEqual(game.timeLeft, 100)
        XCTAssertTrue(dt < game.dTime)
    }
    
    func testGameover() {
        game.setGameOver()
        
        XCTAssertEqual(game.state, .over)
    }

    func testScore() {
        let score = game.score
        game.increaseScore()
        XCTAssertTrue(score < game.score)
    }
    
}
