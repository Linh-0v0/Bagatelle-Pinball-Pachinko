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
        //Determine divice size for UITextField
        //Cuz this does not scale automatically like SpriteKit
        let displaySize: CGRect = UIScreen.main.bounds
        let displayWidth = displaySize.width
        let displayHeight = displaySize.height
        let standardWidth = CGFloat(375)
        let standardHeight = CGFloat(812)
        let ratioWidth: CGFloat
        let ratioHeight: CGFloat
        let textField: UITextField
        //For iphone and ipad
        if (displayWidth < displayHeight) {
            ratioWidth = displayWidth/standardWidth
            ratioHeight = displayHeight/standardHeight
            textField = UITextField(frame: CGRect(x: (displayWidth/2 - 100*ratioWidth), y: (displayHeight/2 + 80*ratioHeight), width: 210*ratioWidth, height: 40*ratioHeight))
        //For Mac where width > height
        } else {
            ratioWidth = displayHeight/standardHeight
            ratioHeight = displayWidth/standardWidth
            textField = UITextField(frame: CGRect(x: (displayWidth/2 - 120*ratioHeight), y: (displayHeight/2 + 40*ratioWidth), width: 210*ratioHeight, height: 40*ratioWidth))
        }
        print("\(displayWidth): \(displayHeight)")
        
       
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
        title.position = CGPoint(x: self.size.width/2 + 10, y: 600)
        title.size = CGSize(width: title.size.width/2, height: title.size.height/2)
        title.zPosition = 10
        title.name = "enterUsername"
        addChild(title)
        
        self.view!.addSubview(textField)

        let submitUsername = SKSpriteNode(imageNamed: "done-btn")
        submitUsername.size = CGSize(width: submitUsername.size.width/1.6, height: submitUsername.size.height/1.6)
        submitUsername.position = CGPoint(x: 360, y: 320)
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

