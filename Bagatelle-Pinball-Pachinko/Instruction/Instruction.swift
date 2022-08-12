//
//  Instruction.swift
//  Bagatelle-Pinball-Pachinko
//
//  Created by Vu Bui Khanh Linh on 12/08/2022.
//

import SpriteKit

class Instruction: SKScene {
    
    var title, detail: SKLabelNode!
    var title2, appName, course, yearPubl, location: SKLabelNode!
    
    override func didMove(to view: SKView) {
        //        let whiteBg = SKSpriteNode(imageNamed: "whiteBg")
        //        whiteBg.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        //        whiteBg.size = CGSize(width: self.size.width, height: 900)
        //        whiteBg.blendMode = .replace
        //        whiteBg.zPosition = 100
        //        self.addChild(whiteBg)
        self.backgroundColor = SKColor.black
        
        let appDetailY: Int = 770
        let appDetailSize: CGFloat = 32
        
        let leftArrow = SKSpriteNode(imageNamed: "left arrow")
        leftArrow.name = "leftArrow"
        leftArrow.position = CGPoint(x: 60, y: self.size.height - 20)
        leftArrow.size = CGSize(width: 50, height: 50)
        addChild(leftArrow)
        
        instructSection(titleStr: "How to Play",
                        titlePosition: CGPoint(x: 70, y: 1200),
                        detailStr: "Each Ball costs 25 Coins. Get more money by Scoring MORE than the Coin you currently have. And see how much Coins you can Get or simply Game Over :)",
                        detailPosition: CGPoint(x: 100, y: 940))
        
        title2 = SKLabelNode(fontNamed: "Chalkduster")
        title2.text = "Application Information"
        title2.fontSize = 45
        title2.horizontalAlignmentMode = .left
        title2.position = CGPoint(x: 70, y: appDetailY)
        addChild(title2)
        
        appName = SKLabelNode(fontNamed: "Chalkduster")
        appName.text = "App Name: Pinball Pachinko"
        appName.fontSize = appDetailSize
        appName.horizontalAlignmentMode = .left
        appName.position = CGPoint(x: 100, y: appDetailY - 80)
        addChild(appName)
        
        course = SKLabelNode(fontNamed: "Chalkduster")
        course.text = "Course: COSC2659"
        course.fontSize = appDetailSize
        course.horizontalAlignmentMode = .left
        course.position = CGPoint(x: 100, y: appDetailY - 80*2)
        addChild(course)
        
        yearPubl = SKLabelNode(fontNamed: "Chalkduster")
        yearPubl.text = "Year Published: 2022"
        yearPubl.fontSize = appDetailSize
        yearPubl.horizontalAlignmentMode = .left
        yearPubl.position = CGPoint(x: 100, y: appDetailY - 80*3)
        addChild(yearPubl)
        
        location = SKLabelNode(fontNamed: "Chalkduster")
        location.text = "Location: Saigon South Campus"
        location.fontSize = appDetailSize
        location.horizontalAlignmentMode = .left
        location.position = CGPoint(x: 100, y: appDetailY - 80*4)
        addChild(location)
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
        detail.fontSize = 32
        detail.preferredMaxLayoutWidth = self.size.width - 130
        detail.numberOfLines = 7
        detail.horizontalAlignmentMode = .left
        detail.position = detailPosition
        addChild(detail)
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
}
