/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Vu Bui Khanh Linh
  ID: 3864120
  Created date: 19/08/2022
  Last modified: 22/08/2022
  Acknowledgement: None
*/

import SpriteKit

class Leaderboard: SKScene {
    var title, colName, usernameCol, scoreCol, ballCol: SKLabelNode!
    var leaderBoardList: [String:[Any]] = Defaults.getLeaderboardList()
    let leaderBoardSize = Defaults.getLeaderboardList().keys.count
    var XPositionValue: CGFloat = 80
    var YPositionValue: CGFloat = 950
    var spaceBtwCol: CGFloat = 350
    
    // Variable for ScrollView
    weak var scrollView: CustomScrollView!
    let moveableNode = SKNode()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black

        // SCROLLVIEW
        scrollView = CustomScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), scene: self, scrollDirection: .vertical, moveableNode: moveableNode)
        // 120px height for each Player's data (100px is for Title and Row name)
        scrollView.contentSize = CGSize(width: self.frame.size.width, height: CGFloat(leaderBoardSize*120 + 350))
        view.addSubview(scrollView)

        addChild(moveableNode)
        
        // Go back Arrow
        let leftArrow = SKSpriteNode(imageNamed: "left arrow")
        leftArrow.name = "leftArrow"
        leftArrow.position = CGPoint(x: 60, y: self.size.height - 20)
        leftArrow.size = CGSize(width: 50, height: 50)
        moveableNode.addChild(leftArrow)
        
        title = SKLabelNode(fontNamed: "Chalkduster")
        title.text = "Leaderboard"
        title.fontSize = 45
        title.horizontalAlignmentMode = .left
        title.position = CGPoint(x: 70, y: 1200)
        moveableNode.addChild(title)
        
        // COLUMN NAME ROW
        colNameRow(colNameStr: "Username", XPosition: XPositionValue)
        colNameRow(colNameStr: "Score", XPosition: XPositionValue + spaceBtwCol)
        colNameRow(colNameStr: "Ball", XPosition: XPositionValue + spaceBtwCol*2 - 160)
        
        for data in leaderBoardList {
            var UserScore = Defaults.getUserLeaderboard(username: data.key).score
            var UserBall = Defaults.getUserLeaderboard(username: data.key).ball
            
            //ADD PLAYER DATA TO LEADERBOARD SCENE
            leaderboardData(username: String(data.key), score: UserScore, ball: UserBall, YPosition: YPositionValue)
            
            YPositionValue -= 120
        }
    }
    
    // MARK: - CREATE OBJECT FUNCTIONS
    func colNameRow(colNameStr: String, XPosition: CGFloat) {
        colName = SKLabelNode(fontNamed: "Chalkduster")
        colName.text = colNameStr
        colName.fontSize = 35
        colName.preferredMaxLayoutWidth = 60
        colName.numberOfLines = 1
        colName.horizontalAlignmentMode = .left
        colName.position = CGPoint(x: XPosition, y: 1100)
        moveableNode.addChild(colName)
    }
    
    func leaderboardData(username: String, score: String, ball: String, YPosition: CGFloat) {
        usernameCol = SKLabelNode(fontNamed: "Chalkduster")
        usernameCol.text = username
        usernameCol.preferredMaxLayoutWidth = 300
        usernameCol.numberOfLines = 2
        usernameCol.horizontalAlignmentMode = .left
        usernameCol.fontSize = 35
        usernameCol.position.x = XPositionValue
        usernameCol.position.y = YPosition
        moveableNode.addChild(usernameCol)
        
        scoreCol = SKLabelNode(fontNamed: "Chalkduster")
        scoreCol.text = score
        scoreCol.horizontalAlignmentMode = .left
        scoreCol.fontSize = 35
        scoreCol.position.x = XPositionValue + spaceBtwCol
        scoreCol.position.y = YPosition
        moveableNode.addChild(scoreCol)
        
        ballCol = SKLabelNode(fontNamed: "Chalkduster")
        ballCol.text = ball
        ballCol.horizontalAlignmentMode = .left
        ballCol.fontSize = 35
        ballCol.position.x = XPositionValue + spaceBtwCol*2 - 150
        ballCol.position.y = YPosition
        moveableNode.addChild(ballCol)
    }
    
}
