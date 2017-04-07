
import Foundation
import Dispatch

public class Mole: Thread {
    
    /* Shared among all Moles */
    static var playing = false
    static var revealedTime = 5.0
    static var moles = [Mole]()
    
    var revealed: Bool
    var whacked: Bool
    var index: Int
    
    var sem: DispatchSemaphore

    init(semaphore: DispatchSemaphore, moleArray: [Mole], which: Int) {
        sem = semaphore
        revealed = false
        whacked = false
        index = which
    }
    
    /* This is the code that is run in a separate thread. */
    override public func main() {
        print("Thread \(self) starting!")
        
        var timeUntilHidden: Date
        
        usleep((arc4random_uniform(5000)))  // to try to make a random dispersion of moles initially
            
        while Mole.playing == true {
            // reset our whack status before revealing again
            Mole.moles[index].whacked = false
            
            // Only certain amount of Moles can be past here at a time
            sem.wait()
            // Calculate how long we stay in here
            timeUntilHidden = Date() + Mole.revealedTime
            // Then reveal ourself
            Mole.moles[index].revealed = true
            // Busy loop: will exit if time exceeds timeUntilHidden, or we get whacked
            while Mole.moles[index].whacked == false {
                if (Date() > timeUntilHidden) {
                    Mole.moles[index].revealed = false
                    break;
                }
            }
            self.revealed = false
            sem.signal()
            
        }
        
        print("Thread \(self) exiting!")
    }
    
}
