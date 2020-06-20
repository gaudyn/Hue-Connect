
import XCTest
@testable import Hue_Connect

class ScoreManagerTests: XCTestCase {
    
    var savedScores = [Int]()
    
    /// Save previous highscores before resetting
    override func setUp() {
        super.setUp()
        self.savedScores = ScoreManager.shared.getScores()
        UserDefaults.standard.removeObject(forKey: "HueConnectHighScores")
        ScoreManager.shared.refreshScores()
    }
    
    /// Load previous highscores after test
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.removeObject(forKey: "HueConnectHighScores")
        for score in savedScores{
            ScoreManager.shared.addScore(score)
        }
    }
    
    /// Test empty highscores
    func testEmpty() throws {
        XCTAssertEqual(ScoreManager.shared.getScores(), [Int]())
    }
    
    /// Test adding single score
    func testSingleAdd() throws {
        let score = 15
        ScoreManager.shared.addScore(score)
        XCTAssertEqual(score, ScoreManager.shared.getScores().first)
        addTeardownBlock {
            UserDefaults.standard.removeObject(forKey: "HueConnectHighScores")
        }
    }
    
    /// Test adding mulitple different scores
    func testMultipleAdd() throws{
        let scores = [15, 16, 17, 200,1000]
        for score in scores{
            ScoreManager.shared.addScore(score)
        }
        print(scores)
        for score in scores{
            XCTAssertTrue(ScoreManager.shared.getScores().contains(score))
        }
        addTeardownBlock {
            UserDefaults.standard.removeObject(forKey: "HueConnectHighScores")
        }
    }
    
    /// Test adding lower scores
    func testAddingHigher() throws{
        let scores = [15, 16, 17, 200,1000, 2000, 15, 15]
        for score in scores{
            ScoreManager.shared.addScore(score)
        }
        for score in scores{
            if score != scores.min(){
                XCTAssertTrue(ScoreManager.shared.getScores().contains(score))
            }
        }
        addTeardownBlock {
            UserDefaults.standard.removeObject(forKey: "HueConnectHighScores")
        }
    }

}
