
import Foundation
import Combine

/// `BoardManager` is responsible for comunication between board and game
protocol BoardManager {
    /// Increase the score in the game
    func increaseScore()
    /// Sets game status to finished level
    func finishLevel()
}

/// Possible game states
enum GameState{
    /// The game is currently running
    case active
    /// The game is paused
    case paused
    /// The game's level has been finished, the game is waiting to proceed
    case finishedLevel
    /// The game is finished
    case over
}

/// Representation of the game
class Game: ObservableObject{
    //MARK: - Properties
    /// Game's board
    @Published var board: Board
    /// Current score
    @Published var score: Int
    /// Available hints
    @Published var hints: Int
    /// Game's timer
    @Published var timer: GameTimer
    /// Game state
    @Published var state: GameState
    /// Game difficulty
    private var currentDifficulty: Int
    /// Used for updating game when the board has been changed
    private var anyCancellable: AnyCancellable? = nil
    
    //MARK: - Initializer
    /// Creates a new board with the lowest difficulty
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
    //MARK: - Changing states
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
    //MARK: - Board control
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
    //MARK: - Timer control
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
    /// Pauses the game
    func pause(){
        self.state = .paused
        self.timer.stop()
    }
    /// Resumes the game
    func unpause(){
        self.state = .active
        self.timer.start()
    }
}
