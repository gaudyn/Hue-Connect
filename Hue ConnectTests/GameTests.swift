
import XCTest
@testable import Hue_Connect

class GameTests: XCTestCase {

    var game = Game()
    
    /// Test resetting routine
    func testReset() {
        game.resetGame()
        
        XCTAssertEqual(game.score, 0)
        XCTAssertEqual(game.state, .active)
        XCTAssertEqual(game.hints, 6)
        XCTAssertEqual(game.timer.timeLeft, 100)
    }
    
    /// Test finishing level routine
    func testFinishLevel() {
        game.finishLevel()
        
        XCTAssertEqual(game.state, .finishedLevel)
    }
    
    /// Test next level routine
    func testNextLevel() {
        let dt = game.dTime
        
        game.nextLevel()
        
        XCTAssertEqual(game.state, .active)
        XCTAssertEqual(game.timer.timeLeft, 100)
        XCTAssertTrue(dt < game.dTime)
    }
    
    /// Test gameover routine
    func testGameover() {
        game.setGameOver()
        
        XCTAssertEqual(game.state, .over)
    }
    
    /// Test increasing game score
    func testScore() {
        let score = game.score
        game.increaseScore()
        XCTAssertTrue(score < game.score)
    }
    
}
