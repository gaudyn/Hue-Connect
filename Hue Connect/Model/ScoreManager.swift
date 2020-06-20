
import Foundation

class ScoreManager{
    
    static let shared = ScoreManager()
    static let maxRecords = 5
    
    private var highScores: [Int]
    private let defaultsKey = "HueConnectHighScores"
    
    private init(){
        let defaults = UserDefaults.standard
        highScores = [Int]()
        highScores = defaults.object(forKey: defaultsKey) as? [Int] ?? [Int]()
    }
    
    /// Replaces local highscores with UserDefaults data
    func refreshScores(){
        let defaults = UserDefaults.standard
        highScores = defaults.object(forKey: defaultsKey) as? [Int] ?? [Int]()
    }
    /// Add score to highscores if it is bigger than the lowest high score or the maximum number of records hasn't been exceeded
    func addScore(_ score: Int){
        highScores.append(score)
        highScores.sort(by: >)
        
        if highScores.count > ScoreManager.maxRecords{
            highScores.removeLast()
        }
        
        saveScores()
    }
    /// Save highscores to user defaults
    private func saveScores(){
        let defaults = UserDefaults.standard
        defaults.set(highScores, forKey: defaultsKey)
    }
    
    /// Returns current sorted highscores
    func getScores() -> [Int]{
        return highScores
    }
    
    
}
