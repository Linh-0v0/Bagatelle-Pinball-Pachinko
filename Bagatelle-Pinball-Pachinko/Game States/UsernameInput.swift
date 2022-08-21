//
//  UsernameInput.swift
//  Bagatelle-Pinball-Pachinko
//
//  Created by Vu Bui Khanh Linh on 17/08/2022.
//

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
