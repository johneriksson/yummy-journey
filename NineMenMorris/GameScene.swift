//
//  GameScene.swift
//  NineMenMorris
//
//  Created by John Eriksson on 2015-11-24.
//  Copyright (c) 2015 John Eriksson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let sprite = SKSpriteNode(imageNamed:"Spaceship")
    var isMovingSprite = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        self.addChild(sprite)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if isMovingSprite {
                sprite.position = location
                isMovingSprite = false
            } else {
                if sprite.containsPoint(location) {
                    isMovingSprite = true
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if sprite.containsPoint(location) {
                sprite.position = location
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
