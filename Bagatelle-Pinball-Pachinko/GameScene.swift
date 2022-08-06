//
//  GameScene.swift
//  Bagatelle-Pinball-Pachinko
//
//  Created by Vu Bui Khanh Linh on 05/08/2022.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    
        makeBouncer(imageName: "pink-loli", position: CGPoint(x: 200, y: 300), size: CGSize(width: self.size.width/5, height: self.size.height/6), zRotation: -1)
        
        makeSlot(position: CGPoint(x: 100, y: 0), markScore: 0)
        makeSlot(position: CGPoint(x: 190, y: 0), markScore: 20)
        makeSlot(position: CGPoint(x: 280, y: 0), markScore: 50)
        makeSlot(position: CGPoint(x: 370, y: 0), markScore: 100)
        makeSlot(position: CGPoint(x: 455, y: 0), markScore: 50)
        makeSlot(position: CGPoint(x: 545, y: 0), markScore: 20)
        makeSlot(position: CGPoint(x: 635, y: 0), markScore: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        let ball = SKSpriteNode(imageNamed: "yellow-ball")
        ball.size = CGSize(width: 50, height: 50)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
        //bounciness
        ball.physicsBody?.restitution = 0.3
        ball.position = location
        addChild(ball)
    }
    
    func makeBouncer(imageName: String, position: CGPoint, size: CGSize, zRotation: CGFloat) {
        let bouncer = SKSpriteNode(imageNamed: imageName)
        bouncer.position = position
        bouncer.size = size
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
        textScore.fontSize = 20
        textScore.fontColor = SKColor.white

        if markScore == 100 {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 80, height: 150)
            textScore.text = "100"
            textScore.position = CGPoint(x: frame.midX, y: frame.midY)
        } else if markScore == 50 {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 80, height: 150)
            textScore.text = "50"
            textScore.position = CGPoint(x: frame.midX, y: frame.midY)
        } else if markScore == 20 {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 80, height: 150)
            textScore.text = "20"
            textScore.position = CGPoint(x: frame.midX, y: frame.midY)
        } else {
            slotBase = SKSpriteNode(imageNamed: "rect slot")
            slotBase.size = CGSize(width: 90, height: 150)
            textScore.text = "0"
            textScore.position = CGPoint(x: frame.midX, y: frame.midY)
        }
        
        slotBase.position = position
        addChild(slotBase)
        addChild(textScore)
    }
}
