//
//  Leaderboard.swift
//  Bagatelle-Pinball-Pachinko
//
//  Created by Vu Bui Khanh Linh on 19/08/2022.
//

import SpriteKit

class Leaderboard: SKScene {
    
    var title, colName, usernameCol, scoreCol, ballCol: SKLabelNode!
    var leaderBoardList: [String:[Any]] = Defaults.getLeaderboardList()
    var XPositionValue: CGFloat = 80
    var YPositionValue: CGFloat = 950
    var spaceBtwCol: CGFloat = 350
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        
        // Go back Arrow
        let leftArrow = SKSpriteNode(imageNamed: "left arrow")
        leftArrow.name = "leftArrow"
        leftArrow.position = CGPoint(x: 60, y: self.size.height - 20)
        leftArrow.size = CGSize(width: 50, height: 50)
        addChild(leftArrow)
        
        title = SKLabelNode(fontNamed: "Chalkduster")
        title.text = "Leaderboard"
        title.fontSize = 45
        title.horizontalAlignmentMode = .left
        title.position = CGPoint(x: 70, y: 1200)
        addChild(title)
        
        colNameRow(colNameStr: "Username", XPosition: XPositionValue)
        colNameRow(colNameStr: "Score", XPosition: XPositionValue + spaceBtwCol)
        colNameRow(colNameStr: "Ball", XPosition: XPositionValue + spaceBtwCol*2 - 160)
        
        for data in leaderBoardList {
            var UserScore = Defaults.getUserLeaderboard(username: data.key).score
            var UserBall = Defaults.getUserLeaderboard(username: data.key).ball
            
            //ADD TO LEADERBOARD SCENE
            leaderboardData(username: String(data.key), score: UserScore, ball: UserBall, YPosition: YPositionValue)
            
            YPositionValue -= 120
//            print("name: \(data.key), score: \(UserScore), ball: \(UserBall)")
        }
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
    
    func colNameRow(colNameStr: String, XPosition: CGFloat) {
        colName = SKLabelNode(fontNamed: "Chalkduster")
        colName.text = colNameStr
        colName.fontSize = 35
        colName.preferredMaxLayoutWidth = 60
        colName.numberOfLines = 1
        colName.horizontalAlignmentMode = .left
        colName.position = CGPoint(x: XPosition, y: 1100)
        addChild(colName)
    }
    
    func leaderboardData(username: String, score: String, ball: String, YPosition: CGFloat) {
        usernameCol = SKLabelNode(fontNamed: "Chalkduster")
        usernameCol.text = username
        usernameCol.preferredMaxLayoutWidth = 300
        usernameCol.numberOfLines = 2
        usernameCol.horizontalAlignmentMode = .left
        usernameCol.fontSize = 35
        usernameCol.position = CGPoint(x: XPositionValue, y: YPosition)
        addChild(usernameCol)
        
        scoreCol = SKLabelNode(fontNamed: "Chalkduster")
        scoreCol.text = score
        scoreCol.horizontalAlignmentMode = .left
        scoreCol.fontSize = 35
        scoreCol.position = CGPoint(x: XPositionValue + spaceBtwCol, y: YPosition)
        addChild(scoreCol)
        
        ballCol = SKLabelNode(fontNamed: "Chalkduster")
        ballCol.text = ball
        ballCol.horizontalAlignmentMode = .left
        ballCol.fontSize = 35
        ballCol.position = CGPoint(x: XPositionValue + spaceBtwCol*2 - 160, y: YPosition)
        addChild(ballCol)
    }
    
}
