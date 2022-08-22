/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Vu Bui Khanh Linh
  ID: 3864120
  Created date: 17/08/2022
  Last modified: 22/08/2022
  Acknowledgement: None
*/

import SpriteKit
import GameKit
import UIKit

class UsernameField: SKScene, UITextFieldDelegate {

    var title: SKLabelNode!
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 85, y: 480, width: 210, height: 30))
        textField.textColor = SKColor(red: 0.71, green: 0.95, blue: 0.99, alpha: 1.00)
        textField.backgroundColor = SKColor(red: 0.16, green: 0.20, blue: 0.38, alpha: 1.00)
        textField.layer.borderColor = CGColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        textField.layer.zPosition = 1
        textField.keyboardType = UIKeyboardType.twitter
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
            return textField
        }()

    override func didMove(to view: SKView) {
        CustomScrollView.disable()
        self.backgroundColor = SKColor.black
        
        let logo = SKSpriteNode(imageNamed: "game-logo")
        logo.position = CGPoint(x: self.size.width/2, y: 900)
        logo.size = CGSize(width: logo.size.width/2.5, height: logo.size.height/2.5)
        logo.zPosition = 10
        logo.name = "logo"
        addChild(logo)
        
        let title = SKSpriteNode(imageNamed: "enter-username")
        title.position = CGPoint(x: self.size.width/2, y: 600)
        title.size = CGSize(width: title.size.width/2, height: title.size.height/2)
        title.zPosition = 10
        title.name = "enterUsername"
        addChild(title)
        
        self.view!.addSubview(textField)

        let submitUsername = SKSpriteNode(imageNamed: "done-btn")
        submitUsername.size = CGSize(width: submitUsername.size.width/1.7, height: submitUsername.size.height/1.7)
        submitUsername.position = CGPoint(x: 370, y: 370)
        submitUsername.name = "submitUsername"
        addChild(submitUsername)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         for touch in touches {
              let location = touch.location(in: self)
              let touchedNode = atPoint(location)
              if touchedNode.name == "submitUsername" {
                  var usernameText = textField.text ?? ""
                  if usernameText != "" {
                      Defaults.save(usernameText, score: "0", ball: "0")
                      
                      let gameScene = GameScene(fileNamed:"GameScene")
                      gameScene?.scaleMode = .aspectFit
                      let transition = SKTransition.moveIn(with: .down, duration: 1)
                      self.view?.presentScene(gameScene!, transition: transition)
                      
                      textField.removeFromSuperview()
                      
                      print(Defaults.getNameScoreBall().username)
                  }
              }
         }
    }
    
}

