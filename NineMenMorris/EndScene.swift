//
//  EndScene.swift
//  NineMenMorris
//
//  Created by John Eriksson on 2015-12-02.
//  Copyright © 2015 John Eriksson. All rights reserved.
//

import SpriteKit

class EndScene: SKScene {
    
    var winner = ""
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.lightGrayColor()
        setupText()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        restart()
    }
    
    func restart() {
        let transition = SKTransition.revealWithDirection(.Right, duration: 1.0)
        
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene!.scaleMode = .ResizeFill
        
        scene?.view?.presentScene(gameScene!, transition: transition)
    }
    
    func setupText() {
        let winnerLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        winnerLabel.text = "Winner: \(winner)"
        winnerLabel.fontSize = CGFloat(30)
        winnerLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        winnerLabel.fontColor = UIColor.greenColor()
        self.addChild(winnerLabel)
        
        let infoLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        infoLabel.text = "Tap anywhere to restart!"
        infoLabel.fontSize = CGFloat(20)
        infoLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        infoLabel.fontColor = UIColor.blackColor()
        self.addChild(infoLabel)
    }

}