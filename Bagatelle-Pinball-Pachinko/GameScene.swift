//
//  GameScene.swift
//  Bagatelle-Pinball-Pachinko
//
//  Created by Vu Bui Khanh Linh on 05/08/2022.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
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
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 650, y: 1250)
        addChild(scoreLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
    
        var randomPositionXArr: [Int] = genRandomNumIncrement(from: 80, to: 680, by: 94)
        var randomPositionYArr: [Int] = genRandomNumIncrement(from: 170, to: 1000, by: 86)
        for _ in 1...60 {
            makeBouncer(imageName: "Plus Symbol-\(Int.random(in: 0..<10))",
                        position: CGPoint(x: randomPositionXArr.randomElement()!, y: randomPositionYArr.randomElement()!),
                        size: CGSize(width: self.size.width/19, height: self.size.height/33),
                        zRotation: Double.random(in: -1..<2), zPosition: 0)
        }

        makeBouncer(imageName: "pink-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: randomPositionYArr.randomElement()!), size: CGSize(width: self.size.width/5, height: self.size.height/6), zRotation: -0.2, zPosition: 1)
        makeBouncer(imageName: "pink-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: randomPositionYArr.randomElement()!), size: CGSize(width: self.size.width/6, height: self.size.height/7), zRotation: -0.055, zPosition: 1)
        makeBouncer(imageName: "black-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: randomPositionYArr.randomElement()!), size: CGSize(width: self.size.width/5, height: self.size.height/6), zRotation: -0.1, zPosition: 1)
        makeBouncer(imageName: "red-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: randomPositionYArr.randomElement()!), size: CGSize(width: self.size.width/9, height: self.size.height/10), zRotation: 0.5, zPosition: 1)
        makeBouncer(imageName: "red-loli", position: CGPoint(x: randomPositionXArr.randomElement()!, y: randomPositionYArr.randomElement()!), size: CGSize(width: self.size.width/7, height: self.size.height/8), zRotation: 0.4, zPosition: 1)
        
        
        makeSlot(position: CGPoint(x: 50, y: 0), markScore: 0)
        makeSlot(position: CGPoint(x: 160 + 10, y: 0), markScore: 20)
        makeSlot(position: CGPoint(x: 260 + 10, y: 0), markScore: 50)
        makeSlot(position: CGPoint(x: 360 + 10, y: 0), markScore: 100)
        makeSlot(position: CGPoint(x: 460 + 10, y: 0), markScore: 50)
        makeSlot(position: CGPoint(x: 560 + 10, y: 0), markScore: 20)
        makeSlot(position: CGPoint(x: 680 + 10, y: 0), markScore: 0)
        
        print(self.size.width)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        let ball = SKSpriteNode(imageNamed: "yellow-ball")
        ball.size = CGSize(width: 40, height: 40)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
        //bounciness
        ball.physicsBody?.restitution = 0.3
//        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.position = location
        ball.name = "ball"
        addChild(ball)
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
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    func genRandomNumIncrement(from: Int, to: Int, by: Int) -> [Int] {
        var randomArr: [Int] = []
        for i in stride(from: from, to: to, by: by) {
            randomArr.append(i)
        }
        return randomArr
    }
}
