
import Foundation

/// `ScoreManager` is responsible for keeping track of the highscores
class ScoreManager{
    //MARK: - Properties
    /// Singleton instance
    static let shared = ScoreManager()
    
    /// Maximum number of saved highscores
    static let maxRecords = 5
    
    /// Highscore array
    private var highScores: [Int]
    /// UserDefaults key to save highscores
    private let defaultsKey = "HueConnectHighScores"
    
    //MARK: - Initializer
    private init(){
        let defaults = UserDefaults.standard
        highScores = [Int]()
        highScores = defaults.object(forKey: defaultsKey) as? [Int] ?? [Int]()
    }
    //MARK: - Data persistance
    /// Replaces local highscores with UserDefaults data
    func refreshScores(){
        let defaults = UserDefaults.standard
        highScores = defaults.object(forKey: defaultsKey) as? [Int] ?? [Int]()
    }
    /// Save highscores to user defaults
    private func saveScores(){
        let defaults = UserDefaults.standard
        defaults.set(highScores, forKey: defaultsKey)
    }
    //MARK: - Accessing data
    /// Add score to highscores if it is bigger than the lowest high score or the maximum number of records hasn't been exceeded
    func addScore(_ score: Int){
        highScores.append(score)
        highScores.sort(by: >)
        
        if highScores.count > ScoreManager.maxRecords{
            highScores.removeLast()
        }
        
        saveScores()
    }
    /// Returns current sorted highscores
    func getScores() -> [Int]{
        return highScores
    }
}
