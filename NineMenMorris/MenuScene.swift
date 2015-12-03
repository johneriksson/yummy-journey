//
//  MenuScene.swift
//  NineMenMorris
//
//  Created by John Eriksson on 2015-12-02.
//  Copyright © 2015 John Eriksson. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var returnScene: GameScene!
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.lightGrayColor()
        setupButtons()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let label = self.nodeAtPoint(location) as? SKLabelNode {
                if label.name == "Restart Button" {
                    restart()
                } else if label.name == "Back Button" {
                    back()
                }
            }
        }
    }
    
    @nonobjc func setReturnScene(scene: GameScene) {
        self.returnScene = scene
    }
    
    func restart() {
        if returnScene != nil {
            returnScene.shouldInitialize = true
            returnToScene()
        }
    }
    
    func back() {
        if returnScene != nil {
            returnScene.shouldInitialize = false
            returnToScene()
        }
    }
    
    func returnToScene() {
        let transition = SKTransition.revealWithDirection(.Up, duration: 1.0)
        scene?.view?.presentScene(returnScene, transition: transition)
    }
    
    func setupButtons() {
        let restartButton = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        restartButton.text = "Restart"
        restartButton.name = "Restart Button"
        restartButton.fontSize = CGFloat(20)
        restartButton.position = CGPoint(x: size.width - size.width / 4, y: size.height - size.height / 6)
        restartButton.fontColor = UIColor(red: CGFloat(0.2), green: CGFloat(0.2), blue: CGFloat(0.4), alpha: CGFloat(1))
        self.addChild(restartButton)
        
        let backButton = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        backButton.text = "Back"
        backButton.name = "Back Button"
        backButton.fontSize = CGFloat(20)
        backButton.position = CGPoint(x: size.width / 4, y: size.height - size.height / 6)
        backButton.fontColor = UIColor(red: CGFloat(0.2), green: CGFloat(0.2), blue: CGFloat(0.4), alpha: CGFloat(1))
        self.addChild(backButton)
    }
}
