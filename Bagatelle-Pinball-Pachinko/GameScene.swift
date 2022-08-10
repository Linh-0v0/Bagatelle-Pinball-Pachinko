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
    var gameContinue : Bool = true {
        didSet {
            let gameOver = childNode(withName: "GameMessageName") as! SKSpriteNode
            let textureName = gameContinue ? "you-won" : "game-over"
            let texture = SKTexture(imageNamed: textureName)
            let actionSequence = SKAction.sequence([SKAction.setTexture(texture),
                                                    SKAction.scale(to: 1.0, duration: 0.25)])
            gameOver.run(actionSequence)
        }
    }
    var isFingerOnbouncer = false
    
    var ballCost = 30
    var scoreLabel, coinLabel, highScoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var coin = 150 {
        didSet {
            coinLabel.text = "Coin: \(coin)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 40
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: 370, y: 1260)
        addChild(scoreLabel)
        
        coinLabel = SKLabelNode(fontNamed: "Chalkduster")
        coinLabel.fontSize = 40
        coinLabel.text = "Coin: 150"
        coinLabel.horizontalAlignmentMode = .center
        coinLabel.fontColor = SKColor.white
        coinLabel.position = CGPoint(x: 370, y: 1200)
        addChild(coinLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        var randomPositionXArr: [Int] = genNumIncrement(from: 70, to: 680, by: 120)
        var randomPositionYArr: [Int] = genNumIncrement(from: 170, to: 1000, by: 97)
        var columnNum = 0
        var numberOfXObjects = randomPositionXArr.capacity
        
        for y in randomPositionYArr {
            var offsetValue = columnNum % 2 == 0 ? 0 : 50
            if columnNum % 2 == 0 {
                for x in randomPositionXArr {
                    makeBouncer(imageName: "Plus Symbol-\(Int.random(in: 0..<10))",
                                position: CGPoint(x: x + offsetValue, y: y),
                                size: CGSize(width: self.size.width/19, height: self.size.height/33),
                                zRotation: Double.random(in: -0.5..<0.25), zPosition: 0)
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
        gameMessage.setScale(0.5)
        addChild(gameMessage)
        
        gameState.enter(WaitingForTap.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enter(Playing.self)
            isFingerOnbouncer = true
            
        case is Playing:
            guard let touch = touches.first else {return}
            let location = touch.location(in: self)
            
            if coin > 0 {
                let ball = SKSpriteNode(imageNamed: "yellow-ball")
                ball.size = CGSize(width: 40, height: 40)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
                //bounciness
                ball.physicsBody?.restitution = 0.3
                ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                ball.position = location
                ball.name = "ball"
                addChild(ball)
                
                coin -= ballCost
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
            slotBase.name = "slot50"
            textScore.text = "50"
            textScore.position = position
        } else if markScore == 20 {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 90, height: 150)
            slotBase.name = "slot20"
            textScore.text = "20"
            textScore.position = position
        } else {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 130, height: 150)
            slotBase.name = "slot0"
            textScore.text = "0"
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
            score += 100
        } else if object.name == "slot50" {
            destroy(ball: ball)
            score += 50
        } else if object.name == "slot20" {
            destroy(ball: ball)
            score += 20
        } else if object.name == "slot0" {
            destroy(ball: ball)
            score += 0
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
                gameContinue = false
            }
            
            if coin < score {
                coin = score
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
        //      var numberOfBricks = 0
        //      self.enumerateChildNodes(withName: BlockCategoryName) {
        //        node, stop in
        //        numberOfBricks = numberOfBricks + 1
        //      }
        //      return numberOfBricks == 0
        var numberOfBalls = 0
        self.enumerateChildNodes(withName: "ball") {
            node, stop in
            numberOfBalls = numberOfBalls + 1
        }
        if coin == 0 && numberOfBalls == 0{
            return false
        } else {
            return true
        }
    }
}
