/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Vu Bui Khanh Linh
  ID: 3864120
  Created date: 17/08/2022
  Last modified: 22/08/2022
  Acknowledgement: None
*/

import UIKit
import SpriteKit
import GameplayKit

class UsernameInput: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
      self.scene = scene as! GameScene
      super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        print("IN USERNAME INPUT MODE")
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is WaitingForTap {
            
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
      return stateClass is WaitingForTap.Type
    }

}
