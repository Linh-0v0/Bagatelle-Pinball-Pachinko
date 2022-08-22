/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Vu Bui Khanh Linh
  ID: 3864120
  Created date: 12/08/2022
  Last modified: 22/08/2022
  Acknowledgement: None
*/

import SpriteKit

class Instruction: SKScene {
    
    var title, detail: SKLabelNode!
    
    override func didMove(to view: SKView) {
        CustomScrollView.disable()
        self.backgroundColor = SKColor.black
        
        // Go back Arrow
        let leftArrow = SKSpriteNode(imageNamed: "left arrow")
        leftArrow.name = "leftArrow"
        leftArrow.position = CGPoint(x: 60, y: self.size.height - 20)
        leftArrow.size = CGSize(width: 50, height: 50)
        addChild(leftArrow)
        
        instructSection(titleStr: "How to Play",
                        titlePosition: CGPoint(x: 70, y: 1200),
                        detailStr: "- You initially have 125 coins in your pocket.\n- Each Ball costs 25 Coins.\n- Get more money by Scoring MORE than the Coin you currently have.\n- You're Game Over when you're out of Coin.\n- And WIN the game by reaching 1000 points. \n- Leaderboard will save each player's highest score which larger than 0.",
                        detailPosition: CGPoint(x: 90, y: 600))
        
        instructSection(titleStr: "Application Information",
                        titlePosition: CGPoint(x: 70, y: 460),
                        detailStr: "- App Name: Pinball Pachinko \n- Course: COSC2659 \n- Year Published: 2022 \n- Location: Saigon South Campus",
                        detailPosition: CGPoint(x: 100, y: 200))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "leftArrow" {
            let gameScene = GameScene(fileNamed:"GameScene")
            gameScene?.scaleMode = .aspectFit
            let transition = SKTransition.moveIn(with: .left, duration: 1)
            self.view?.presentScene(gameScene!, transition: transition)
        }
    }
    
    func instructSection(titleStr: String, titlePosition: CGPoint, detailStr: String, detailPosition: CGPoint) {
        title = SKLabelNode(fontNamed: "Chalkduster")
        title.text = titleStr
        title.fontSize = 45
        title.horizontalAlignmentMode = .left
        title.position = titlePosition
        addChild(title)
        
        detail = SKLabelNode(fontNamed: "Chalkduster")
        detail.text = detailStr
        detail.fontSize = 35
        detail.preferredMaxLayoutWidth = self.size.width - 130
        detail.numberOfLines = 15
        detail.horizontalAlignmentMode = .left
        detail.position = detailPosition
        addChild(detail)
    }
}
