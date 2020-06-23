
import Foundation

/// Game delegate used by timer
protocol GameDelegate {
    /// Value of time difference
    var dTime: Double { get }
    /// Sets game's state to gameover
    func setGameOver()
}

/// Game timer class
/// - Warning: Use start() or reset() before use
class GameTimer: ObservableObject{
    //MARK: - Properties
    /// Amount of time left
    @Published var timeLeft: Double
    
    /// Maximum time of the game
    private let maxTime: Double = 100
    
    /// Timer for the game
    private var timer: Timer?
    
    /// Game owner of the timer
    var delegate: GameDelegate?
    
    //MARK: - Initializer
    init() {
        self.timeLeft = maxTime
    }
    
    //MARK: - Timer methods
    
    /// Starts the game timer
    func start(){
        guard timer == nil else {
            return
        }
        self.timer = Timer(timeInterval: 0.01, repeats: true){ _ in
            self.fireTimer()
        }
        RunLoop.main.add(self.timer!, forMode: .common)
        
    }
    /// Stops the game timer
    func stop(){
        guard timer != nil else {
            return
        }
        timer?.invalidate()
        timer = nil
    }
    /// Starts the game timer and resets the available time
    func reset(){
        timeLeft = maxTime
        start()
    }
    /// Decreases the available time and sets the game over is the time runs out
    private func fireTimer(){
        if timeLeft > 0 {
            timeLeft -= delegate?.dTime ?? 0.001
        } else {
            stop()
            delegate?.setGameOver()
        }
    }
}
