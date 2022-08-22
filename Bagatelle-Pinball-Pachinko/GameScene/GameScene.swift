/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Vu Bui Khanh Linh
  ID: 3864120
  Created date: 05/08/2022
  Last modified: 22/08/2022
  Acknowledgement:
    - Sound: https://mixkit.co/free-sound-effects/game/
    - Game States Logic: https://www.raywenderlich.com/1160-how-to-make-a-breakout-game-with-spritekit-and-swift-part-2
*/

import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - GAME STATES
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        UsernameInput(scene: self),
        WaitingForTap(scene: self),
        Playing(scene: self),
        GameOver(scene: self)])
    var gameOver: SKSpriteNode!
    
    // MARK: - SOUND
    let gameOverSound = SKAction.playSoundFileNamed("game-over", waitForCompletion: false)
    let gameWonSound = SKAction.playSoundFileNamed("game-won", waitForCompletion: false)
    let tapToPlaySound = SKAction.playSoundFileNamed("tap-start", waitForCompletion: false)
    let clickSound = SKAction.playSoundFileNamed("click", waitForCompletion: false)
    let ballSound = SKAction.playSoundFileNamed("ball-tap", waitForCompletion: false)
    let slot100Sound = SKAction.playSoundFileNamed("score-100", waitForCompletion: false)
    let slotScorePointSound = SKAction.playSoundFileNamed("score-point", waitForCompletion: false)
    let slotMinusSound = SKAction.playSoundFileNamed("minus-point", waitForCompletion: false)
    
    // MARK: - WIN/LOSE STATE
    var gameWinOrLose : Bool = true {
        didSet {
            let gameOver = childNode(withName: "GameMessageName") as! SKSpriteNode
            let textureName = gameWinOrLose ? (isGameWon() ? "you-won" : "") : "game-over"
            let texture = SKTexture(imageNamed: textureName)
            
            let actionSequence = SKAction.sequence(
                [gameWinOrLose ? gameWonSound : gameOverSound,
                 SKAction.setTexture(texture), SKAction.scale(to: 1.0, duration: 0.25)])
            gameOver.run(actionSequence)
        }
    }
    
    // MARK: - GAME VARIABLES
    var ballCost = 25
    var scoreLabel, coinLabel, highScoreLabel: SKLabelNode!
    var ballDroppedNum = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var coin = 625 {
        didSet {
            coinLabel.text = "Coin: \(coin)"
        }
    }
    
    // MARK: - GAME OBJECTS BUILD
    override func didMove(to view: SKView) {
        CustomScrollView.disable()
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let renew = SKSpriteNode(imageNamed: "renew")
        renew.isUserInteractionEnabled = false
        renew.position = CGPoint(x: 70, y: frame.size.height - 100)
        renew.size = CGSize(width: 70, height: 70)
        renew.zPosition = 10
        renew.name = "renewButton"
        addChild(renew)
        
        let addUsername = SKSpriteNode(imageNamed: "add-username")
        addUsername.isUserInteractionEnabled = false
        addUsername.position = CGPoint(x: 160, y: frame.size.height - 100)
        addUsername.size = CGSize(width: 65, height: 65)
        addUsername.zPosition = 10
        addUsername.name = "addNewUsername"
        addChild(addUsername)
        
        let instruction = SKSpriteNode(imageNamed: "info")
        instruction.isUserInteractionEnabled = false
        instruction.position = CGPoint(x: frame.size.width - 70, y: frame.size.height - 100)
        instruction.size = CGSize(width: 70, height: 70)
        instruction.zPosition = 10
        instruction.name = "instructionButton"
        addChild(instruction)
        
        let leaderboardBtn = SKSpriteNode(imageNamed: "leaderboard")
        leaderboardBtn.isUserInteractionEnabled = false
        leaderboardBtn.position = CGPoint(x: frame.size.width - 160, y: frame.size.height - 100)
        leaderboardBtn.size = CGSize(width: 50, height: 50)
        leaderboardBtn.zPosition = 10
        leaderboardBtn.name = "leaderboardButton"
        addChild(leaderboardBtn)
        
        let line = SKSpriteNode(imageNamed: "line")
        line.isUserInteractionEnabled = false
        line.position = CGPoint(x: frame.size.width / 2, y: 1005)
        line.size = CGSize(width: self.size.width, height: 2)
        line.zPosition = 10
        line.name = "line"
        addChild(line)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 40
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: 370, y: 1260)
        addChild(scoreLabel)
        
        coinLabel = SKLabelNode(fontNamed: "Chalkduster")
        coinLabel.fontSize = 40
        coinLabel.text = "Coin: 625"
        coinLabel.horizontalAlignmentMode = .center
        coinLabel.fontColor = SKColor.white
        coinLabel.position = CGPoint(x: 370, y: 1200)
        addChild(coinLabel)
        
        // ADD PHYSICS TO THE GAME
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        let randomPositionXArr: [Int] = genNumIncrement(from: 70, to: 680, by: 120)
        let randomPositionYArr: [Int] = genNumIncrement(from: 170, to: 1000, by: 97)
        var columnNum = 0
        let numberOfXObjects = randomPositionXArr.capacity
        
        //Plus (+) Objects
        for y in randomPositionYArr {
            var offsetValue = columnNum % 2 == 0 ? 0 : 50
            if columnNum % 2 == 0 {
                for x in randomPositionXArr {
                    makeBouncer(imageName: "Plus Symbol-\(Int.random(in: 0..<10))",
                                position: CGPoint(x: x + offsetValue, y: y),
                                size: CGSize(width: self.size.width/19, height: self.size.height/33),
                                zRotation: Double.random(in: -0.5..<0.5), zPosition: 0)
                }
            } else {
                for x in randomPositionXArr[0..<numberOfXObjects - 3] {
                    makeBouncer(imageName: "Plus Symbol-\(Int.random(in: 0..<10))",
                                position: CGPoint(x: x + offsetValue, y: y),
                                size: CGSize(width: self.size.width/19, height: self.size.height/33),
                                zRotation: Double.random(in: -0.5..<0.25), zPosition: 0)
                }
            }
            columnNum += 1
        }
        // Lolipop Objects
        makeBouncer(imageName: "pink-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: 950), size: CGSize(width: self.size.width/12, height: self.size.height/13), zRotation: -0.2, zPosition: 1)
        makeBouncer(imageName: "red-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: 760), size: CGSize(width: self.size.width/17, height: self.size.height/18), zRotation: 0.4, zPosition: 1)
        makeBouncer(imageName: "pink-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: 555), size: CGSize(width: self.size.width/19, height: self.size.height/20), zRotation: -0.055, zPosition: 1)
        makeBouncer(imageName: "black-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: 360), size: CGSize(width: self.size.width/13, height: self.size.height/14), zRotation: -0.1, zPosition: 1)
        makeBouncer(imageName: "red-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: 150), size: CGSize(width: self.size.width/13, height: self.size.height/14), zRotation: 0.5, zPosition: 1)
        
        
        // Score Slot Objects (Note: markScore: 0 = -25Slot)
        makeSlot(position: CGPoint(x: 50, y: 0), markScore: 0)
        makeSlot(position: CGPoint(x: 160 + 10, y: 0), markScore: 50)
        makeSlot(position: CGPoint(x: 260 + 10, y: 0), markScore: -10)
        makeSlot(position: CGPoint(x: 360 + 10, y: 0), markScore: 100)
        makeSlot(position: CGPoint(x: 460 + 10, y: 0), markScore: -10)
        makeSlot(position: CGPoint(x: 560 + 10, y: 0), markScore: 50)
        makeSlot(position: CGPoint(x: 680 + 10, y: 0), markScore: 0)
        
        // Tap To Play
        let gameMessage = SKSpriteNode(imageNamed: "tap-to-play")
        gameMessage.name = "GameMessageName"
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
        gameMessage.zPosition = 10
        gameMessage.size = CGSize(width: self.size.width - 100, height: 50)
        gameMessage.run(tapToPlaySound)
        addChild(gameMessage)
        
        // MARK: - CLEAR USERDEFAULTS
//            Defaults.clearUserSessionData()
//            Defaults.clearAllUsers()
//            Defaults.clearAllLeaderboard()
        
        print("USERNAME: \(Defaults.getNameScoreBall().username.capitalized)")
        print(Defaults.getUserLeaderboard(username: Defaults.getNameScoreBall().username))
        
        // RUN THE INITIAL STATE OF THE GAME
        // if NOT logged-in, go to the UsernameField View (to input username)
        if Defaults.getNameScoreBall().username.isEmpty {
            gameState.enter(UsernameInput.self)
            
            let newScene = UsernameField(fileNamed:"UsernameField")
           newScene!.scaleMode = .aspectFit
           let scale = SKAction.scale(to: 1.0, duration: 0.25)
           let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
           self.view?.presentScene(newScene!, transition: reveal)
        
        } else {
            gameState.enter(WaitingForTap.self)
        }

    }
    
    // MARK: - ACTIONS WHEN TOUCH
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        // When touch the "Instruction" button, open the "Instruction" view scene
        if touchedNode.name == "instructionButton" {
            touchedNode.run(clickSound)
            let instructionScene = Instruction(fileNamed:"Instruction")
            instructionScene?.scaleMode = .aspectFit
            let transition = SKTransition.moveIn(with: .down, duration: 1)
            self.view?.presentScene(instructionScene!, transition: transition)
        }
        
        // When touch the "addNewUserName" button, open the "Username" view scene
        if touchedNode.name == "addNewUsername" {
            touchedNode.run(clickSound)
            gameState.enter(UsernameInput.self)
            
            let newScene = UsernameField(fileNamed:"UsernameField")
           newScene!.scaleMode = .aspectFit
           let scale = SKAction.scale(to: 1.0, duration: 0.25)
           let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
           self.view?.presentScene(newScene!, transition: reveal)
        }
        
        // When touch the "leaderboardButton" button, open the "Leaderboard" view scene
        if touchedNode.name == "leaderboardButton" {
            touchedNode.run(clickSound)
            print("Touch Leaderboard")
            
            let newScene = Leaderboard(fileNamed:"Leaderboard")
           newScene!.scaleMode = .aspectFit
           let scale = SKAction.scale(to: 1.0, duration: 0.25)
           let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
           self.view?.presentScene(newScene!, transition: reveal)
        }
        
        // Different game actions when touch (screen) based on the GAME STATES
        switch gameState.currentState {
        case is UsernameInput:
            gameState.enter(WaitingForTap.self)
            
        case is WaitingForTap:
            gameState.enter(Playing.self)
            
        case is Playing:
            // Renew game when "Renew button" is touched
            if touchedNode.name == "renewButton" {
                touchedNode.run(clickSound)
                let newScene = GameScene(fileNamed:"GameScene")
                newScene!.scaleMode = .aspectFit
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                self.view?.presentScene(newScene!, transition: reveal)
            }
            
            // When player has coins, and ball is only allowed to drop in specific field (above the white line)
            if coin > 0 {
                if location.y > 1010 {
                    let ball = SKSpriteNode(imageNamed: "yellow-ball")
                    ball.size = CGSize(width: 40, height: 40)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
                    //bounciness
                    ball.physicsBody?.restitution = 0.3
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.position = location
                    ball.name = "ball"
                    ball.run(ballSound)
                    addChild(ball)
                    
                    // Coin is substracted for each ball
                    coin -= ballCost
                }
            }
            
        // Renew the game when Game Over (run this GameScene file again)
        case is GameOver:
            let newScene = GameScene(fileNamed:"GameScene")
            newScene!.scaleMode = .aspectFit
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(newScene!, transition: reveal)
            
        default:
            break
        }
    }
    
    // MARK: - BOUNCER (GAME OBJECTS)
    func makeBouncer(imageName: String, position: CGPoint, size: CGSize, zRotation: CGFloat, zPosition: Int) {
        let bouncer = SKSpriteNode(imageNamed: imageName)
        bouncer.position = position
        bouncer.zPosition = CGFloat(zPosition)
        bouncer.size = size
        bouncer.name = "bouncer"
        bouncer.zRotation = zRotation
        bouncer.physicsBody = SKPhysicsBody(texture: bouncer.texture!, size: bouncer
            .size)
        // When collides, the object with 'isDynamic=false' won't move
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    // MARK: - SCORE/POINT SLOT
    func makeSlot(position: CGPoint, markScore: Int) {
        var slotBase: SKSpriteNode
        let textScore = SKLabelNode(fontNamed: "Chalkduster")
        textScore.fontSize = 40
        textScore.fontColor = SKColor.white
        
        if markScore == 100 {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 90, height: 150)
            slotBase.name = "slot100"
            textScore.text = "100"
            textScore.position = position
        } else if markScore == -10 {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 90, height: 150)
            slotBase.name = "slot-10"
            textScore.text = "-10"
            textScore.position = position
        } else if markScore == 50 {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 90, height: 150)
            slotBase.name = "slot50"
            textScore.text = "50"
            textScore.position = position
        } else {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 130, height: 150)
            slotBase.name = "slot-25"
            textScore.text = "-25"
            textScore.position = position
        }
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        addChild(slotBase)
        addChild(textScore)
    }
    
    // MARK: - ACTIONS IN COLLISION
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "slot100" {
            destroy(ball: ball)
            object.run(slot100Sound)
            score += 100
        } else if object.name == "slot50" {
            destroy(ball: ball)
            object.run(slotScorePointSound)
            score += 50
        } else if object.name == "slot-10" {
            destroy(ball: ball)
            object.run(slotMinusSound)
            score -= 10
        } else if object.name == "slot-25" {
            destroy(ball: ball)
            object.run(slotMinusSound)
            score -= 25
        }
    }
    
    // DESTROY BALL
    func destroy(ball: SKNode) {
        if let bokehParticle = SKEmitterNode(fileNamed: "BokehEffect") {
            bokehParticle.position = ball.position
            addChild(bokehParticle)
        }
        // Count the number of ball has been dropped
        ballDroppedNum += 1
        //        remove the node from the game
        ball.removeFromParent()
    }
    
    // MARK: - didBegin RUNS ALL THE TIME
    func didBegin(_ contact: SKPhysicsContact) {
        if gameState.currentState is Playing {
            guard let nodeA = contact.bodyA.node else { return }
            guard let nodeB = contact.bodyB.node else { return }
            
            // When Ball collides with other Objects
            if nodeA.name == "ball" {
                collisionBetween(ball: nodeA, object: nodeB)
            } else if nodeB.name == "ball" {
                collisionBetween(ball: nodeB, object: nodeA)
            }
            
            // Game stops when Game Over
            if !isGameContinue() {
                checkHighScore()
                gameState.enter(GameOver.self)
                gameWinOrLose = false
            }
            
            // Game stops when Won
            if isGameWon() {
                checkHighScore()
              gameState.enter(GameOver.self)
              gameWinOrLose = true
            }
        }
    }
    
    // MARK: - OTHER CONDITION METHODS
    // Generate Array for Objects Position
    func genNumIncrement(from: Int, to: Int, by: Int) -> [Int] {
        var Arr: [Int] = []
        for i in stride(from: from, to: to, by: by) {
            Arr.append(i)
        }
        return Arr
    }
    
    // Check if the Game should be continued
    func isGameContinue() -> Bool {
        var numberOfBalls = 0
        // Check if there is any Ball staying at the moment
        self.enumerateChildNodes(withName: "ball") {
            node, stop in
            numberOfBalls = numberOfBalls + 1
        }
        if (coin <= 0 && numberOfBalls == 0) {
//            LOSE when Out of Coin and No Ball is left on the screen
            return false
        } else {
//            CONTINUE
            return true
        }
    }
    
    // Win when Score >= 800
    func isGameWon() -> Bool {
        if score >= 800 {
            return true
        } else {
            return false
        }
    }
    
    // Check Score to put in the Leaderboard
    func checkHighScore() {
        var username = Defaults.getNameScoreBall().username
        var oldHighScore: Int? = Int(Defaults.getUserLeaderboard(username: username).score)
        var oldBallDroppedNum: Int? = Int(Defaults.getNameScoreBall().ball)
        
        if score > oldHighScore! && score > 0 {
            Defaults.save(username, score: String(score), ball: String(ballDroppedNum))
            Defaults.saveToLeaderboard(username, score: String(score), ball: String(ballDroppedNum))
        }
        
        if isGameWon() {
            if (ballDroppedNum > 0) && (ballDroppedNum < oldBallDroppedNum!) {
                Defaults.save(username, score: String(score), ball: String(ballDroppedNum))
                Defaults.saveToLeaderboard(username, score: String(score), ball: String(ballDroppedNum))
            }
        }
    }
}
