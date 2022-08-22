/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Vu Bui Khanh Linh
  ID: 3864120
  Created date: 17/08/2022
  Last modified: 22/08/2022
  Acknowledgement:
    - Game States Logic: https://www.raywenderlich.com/1160-how-to-make-a-breakout-game-with-spritekit-and-swift-part-2
*/

import SpriteKit
import GameplayKit

class WaitingForTap: GKState {
  unowned let scene: GameScene
  
  init(scene: SKScene) {
    self.scene = scene as! GameScene
    super.init()
  }
  
  override func didEnter(from previousState: GKState?) {
      let scale = SKAction.scale(to: 1.0, duration: 0.25)
        scene.childNode(withName: "GameMessageName")!.run(scale)
      print("IN WAITING FOR TAP MODE")
  }
  
  override func willExit(to nextState: GKState) {
      if nextState is Playing {
          let scale = SKAction.scale(to: 0, duration: 0.4)
          scene.childNode(withName: "GameMessageName")!.run(scale)
        }
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is Playing.Type
  }

}
