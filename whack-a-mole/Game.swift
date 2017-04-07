//
//  Game.swift
//  test
//
//  Created by Gaelen on 3/26/17.
//  Copyright © 2017 Gaelen. All rights reserved.
//

import Foundation
import Dispatch
import UIKit

class Game : Thread {
    
    /* Game Parameters */
    var numMoles: Int
    var maxMolesShown: Int
    
    /* Performance Stats */
    var molesWhacked: Int
    
    /* Game data */
    var moles = [Mole]()
    let sem: DispatchSemaphore

    init(numMoles: Int, maxMolesShown: Int) {
        self.numMoles = numMoles
        self.maxMolesShown = maxMolesShown
        
        molesWhacked = 0
        
        sem = DispatchSemaphore(value: maxMolesShown)
        // Create array of Mole objects
        for i in 0..<numMoles {
            moles.append(Mole(semaphore: sem, moleArray: moles, which: i))
        }
        // Gives Moles shared access to the array
        Mole.moles = moles
    }
    
    func stop() {
        /* Tells game thread and all Mole threads to do one last loop iteration */
        Mole.playing = false
        print("Moles Whacked: \(molesWhacked)")
        
        print("Waiting on threads to exit...")
        /* Wait for all moles to exit */
        for mole in moles {
            while mole.isExecuting {}
        }
        /* Wait for the game thread if it's not done exiting */
        while self.isExecuting {}
    }
    
    func whack(moleIndex: Int) -> Bool {
        // if moleIndex is less than the size of Mole array and greater than -1
        if moleIndex < moles.count && moleIndex >= 0 {
            // Then only whack if it's already revealed
            if moles[moleIndex].revealed {
                moles[moleIndex].whacked = true
                molesWhacked += 1
                return true
            }
        }
        return false
    }
    
    // This function executes in a separate thread
    override func main()  {
        
        Mole.playing = true
        for i in 0..<numMoles {
            moles[i].start()
        }
        
        // This is not synchcronized with the Moles.
        // Only prints as fast as it possibly can.
        while Mole.playing == true {
            for i in 0..<numMoles {
                if moles[i].revealed {
                    print("@  ", terminator: "")
                } else {
                    print("-  ", terminator: "")
                }
                
            }
            print()
            usleep(500) // To keep my laptop fan from turning on
        }
        
        print("Game thread exiting.")
    }
}
