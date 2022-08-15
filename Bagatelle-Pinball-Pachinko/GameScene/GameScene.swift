//
//  GameScene.swift
//  Bagatelle-Pinball-Pachinko
//
//  Created by Vu Bui Khanh Linh on 05/08/2022.
//

import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        WaitingForTap(scene: self),
        Playing(scene: self),
        GameOver(scene: self)])
    var gameOver: SKSpriteNode!
    
    let gameOverSound = SKAction.playSoundFileNamed("game-over", waitForCompletion: false)
    let tapToPlaySound = SKAction.playSoundFileNamed("tap-start", waitForCompletion: false)
    let clickSound = SKAction.playSoundFileNamed("click", waitForCompletion: false)
    let ballSound = SKAction.playSoundFileNamed("ball-tap", waitForCompletion: false)
    let slot100Sound = SKAction.playSoundFileNamed("score-100", waitForCompletion: false)
    let slotScorePointSound = SKAction.playSoundFileNamed("score-point", waitForCompletion: false)
    let slotMinusSound = SKAction.playSoundFileNamed("minus-point", waitForCompletion: false)
    
    var gameWinOrLose : Bool = true {
        didSet {
            let gameOver = childNode(withName: "GameMessageName") as! SKSpriteNode
            let textureName = gameWinOrLose ? (isGameWon() ? "you-won" : "") : "game-over"
            let texture = SKTexture(imageNamed: textureName)
            
            let actionSequence = SKAction.sequence([gameOverSound, SKAction.setTexture(texture),
                                                    SKAction.scale(to: 1.0, duration: 0.25)])
            gameOver.run(actionSequence)
        }
    }
    var isFingerOnbouncer = false
    
    var ballCost = 25
    var scoreLabel, coinLabel, highScoreLabel, gameNotif: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var coin = 125 {
        didSet {
            coinLabel.text = "Coin: \(coin)"
        }
    }
    //    var highScore = 0 {
    //        didSet {
    //            highScoreLabel.text = "High Score: \(highScore)"
    //        }
    //    }
    
    override func didMove(to view: SKView) {
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
        
        let instruction = SKSpriteNode(imageNamed: "info")
        instruction.isUserInteractionEnabled = false
        instruction.position = CGPoint(x: frame.size.width - 70, y: frame.size.height - 100)
        instruction.size = CGSize(width: 70, height: 70)
        instruction.zPosition = 10
        instruction.name = "instructionButton"
        addChild(instruction)
        
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
        coinLabel.text = "Coin: 125"
        coinLabel.horizontalAlignmentMode = .center
        coinLabel.fontColor = SKColor.white
        coinLabel.position = CGPoint(x: 370, y: 1200)
        addChild(coinLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        let randomPositionXArr: [Int] = genNumIncrement(from: 70, to: 680, by: 120)
        let randomPositionYArr: [Int] = genNumIncrement(from: 170, to: 1000, by: 97)
        var columnNum = 0
        let numberOfXObjects = randomPositionXArr.capacity
        
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
        
        makeBouncer(imageName: "pink-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: 950), size: CGSize(width: self.size.width/12, height: self.size.height/13), zRotation: -0.2, zPosition: 1)
        makeBouncer(imageName: "red-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: 760), size: CGSize(width: self.size.width/17, height: self.size.height/18), zRotation: 0.4, zPosition: 1)
        makeBouncer(imageName: "pink-loli", position: CGPoint(x: randomPositionXArr.randomElement()! + 40, y: 640), size: CGSize(width: self.size.width/19, height: self.size.height/20), zRotation: -0.055, zPosition: 1)
        makeBouncer(imageName: "black-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: 360), size: CGSize(width: self.size.width/13, height: self.size.height/14), zRotation: -0.1, zPosition: 1)
        makeBouncer(imageName: "red-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: 150), size: CGSize(width: self.size.width/13, height: self.size.height/14), zRotation: 0.5, zPosition: 1)
        
        
        
        makeSlot(position: CGPoint(x: 50, y: 0), markScore: 0)
        makeSlot(position: CGPoint(x: 160 + 10, y: 0), markScore: 20)
        makeSlot(position: CGPoint(x: 260 + 10, y: 0), markScore: 50)
        makeSlot(position: CGPoint(x: 360 + 10, y: 0), markScore: 100)
        makeSlot(position: CGPoint(x: 460 + 10, y: 0), markScore: 50)
        makeSlot(position: CGPoint(x: 560 + 10, y: 0), markScore: 20)
        makeSlot(position: CGPoint(x: 680 + 10, y: 0), markScore: 0)
        
        //        TAP TO PLAY
        let gameMessage = SKSpriteNode(imageNamed: "tap-to-play")
        gameMessage.name = "GameMessageName"
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
        gameMessage.zPosition = 10
        gameMessage.size = CGSize(width: self.size.width - 100, height: 50)
        
        gameMessage.run(tapToPlaySound)
        addChild(gameMessage)
        
        gameState.enter(WaitingForTap.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "instructionButton" {
            
            touchedNode.run(clickSound)
            let instructionScene = Instruction(fileNamed:"Instruction")
            instructionScene?.scaleMode = .aspectFit
            let transition = SKTransition.moveIn(with: .down, duration: 1)
            self.view?.presentScene(instructionScene!, transition: transition)
        }
        
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enter(Playing.self)
            isFingerOnbouncer = true
            
        case is Playing:
            if touchedNode.name == "renewButton" {
                touchedNode.run(clickSound)
                let newScene = GameScene(fileNamed:"GameScene")
                newScene!.scaleMode = .aspectFit
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                self.view?.presentScene(newScene!, transition: reveal)
            }
            
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
                    
                    coin -= ballCost
                    
                }
            }
            
            if let body = physicsWorld.body(at: location) {
                if body.node!.name == "bouncer" {
                    isFingerOnbouncer = true
                }
            }
            
        case is GameOver:
            let newScene = GameScene(fileNamed:"GameScene")
            newScene!.scaleMode = .aspectFit
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(newScene!, transition: reveal)
            
        default:
            break
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        gameState.update(deltaTime: currentTime)
    }
    
    func makeBouncer(imageName: String, position: CGPoint, size: CGSize, zRotation: CGFloat, zPosition: Int) {
        let bouncer = SKSpriteNode(imageNamed: imageName)
        bouncer.position = position
        bouncer.zPosition = CGFloat(zPosition)
        bouncer.size = size
        bouncer.name = "bouncer"
        bouncer.zRotation = zRotation
        bouncer.physicsBody = SKPhysicsBody(texture: bouncer.texture!, size: bouncer
            .size)
        //        when collides, the object with 'isDynamic=false' won't move
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
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
        } else if markScore == 50 {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 90, height: 150)
            slotBase.name = "slot-10"
            textScore.text = "-10"
            textScore.position = position
        } else if markScore == 20 {
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
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "slot100" {
            destroy(ball: ball)
            object.run(slot100Sound)
            score += 100
            if coin < score {
                coin = score
            }
        } else if object.name == "slot50" {
            destroy(ball: ball)
            object.run(slotScorePointSound)
            score += 50
            if coin < score {
                coin = score
            }
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
    
    func destroy(ball: SKNode) {
        if let bokehParticle = SKEmitterNode(fileNamed: "BokehEffect") {
            bokehParticle.position = ball.position
            addChild(bokehParticle)
        }
        //        remove the node from the game
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameState.currentState is Playing {
            // Previous code remains here...
            guard let nodeA = contact.bodyA.node else { return }
            guard let nodeB = contact.bodyB.node else { return }
            
            if nodeA.name == "ball" {
                collisionBetween(ball: nodeA, object: nodeB)
            } else if nodeB.name == "ball" {
                collisionBetween(ball: nodeB, object: nodeA)
            }
            
            if !isGameContinue() {
                gameState.enter(GameOver.self)
                gameWinOrLose = false
            }
            
            if isGameWon() {
              gameState.enter(GameOver.self)
              gameWinOrLose = true
            }
        }
    }
    
    func genNumIncrement(from: Int, to: Int, by: Int) -> [Int] {
        var randomArr: [Int] = []
        for i in stride(from: from, to: to, by: by) {
            randomArr.append(i)
        }
        return randomArr
    }
    
    func isGameContinue() -> Bool {
        var numberOfBalls = 0
        self.enumerateChildNodes(withName: "ball") {
            node, stop in
            numberOfBalls = numberOfBalls + 1
        }
        if (coin == 0 && numberOfBalls == 0) {
//            LOSE
            return false
        } else {
//            CONTINUE
            return true
        }
    }
    
    func isGameWon() -> Bool {
        if score == 1000 {
            return true
        } else {
            return false
        }
    }
}
