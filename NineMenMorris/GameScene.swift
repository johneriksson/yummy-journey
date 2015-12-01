//
//  GameScene.swift
//  NineMenMorris
//
//  Created by John Eriksson on 2015-11-24.
//  Copyright (c) 2015 John Eriksson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let brain = NineMenMorrisRules()
    
    var boardPositions = Array<CGPoint>()
    var boardPositionSprites = Array<SKSpriteNode>()
    
    var blueCheckers = Array<SKSpriteNode>()
    var redCheckers = Array<SKSpriteNode>()
    
    let widthFactor = CGFloat(0.87)
    let heightFactor = CGFloat(0.6)
    
    var checkerCurrentlyMoving: SKSpriteNode!
    var colorMoving = 0
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.whiteColor()
        setupBoardPositions()
        setupCheckers()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let sprite = self.nodeAtPoint(location) as? SKSpriteNode {
                if blueCheckers.contains(sprite) {
                    colorMoving = 1
                    checkerCurrentlyMoving = sprite
                } else if redCheckers.contains(sprite) {
                    colorMoving = 2
                    checkerCurrentlyMoving = sprite
                } else if boardPositionSprites.contains(sprite) && checkerCurrentlyMoving != nil {
                    if let to = boardPositionSprites.indexOf(sprite) {
                        var from: Int {
                            if let index = boardPositions.indexOf(checkerCurrentlyMoving.position) {
                                return index
                            } else {
                                return 0
                            }
                        }
                        if brain.legalMove(to, from: from, color: colorMoving) {
                            checkerCurrentlyMoving.position = sprite.position
                        }
                    }
                
                    checkerCurrentlyMoving = nil
                }
            }
        }
    }
    
    func setupBoardPositions() {
        let customFrameWidth = size.width * widthFactor
        let customFrameHeight = size.height * heightFactor
        let dotSize = CGSize(width: CGFloat(10.0), height: CGFloat(10.0))
        let rowHeight = customFrameHeight / CGFloat(7)
        let yStart = customFrameHeight / CGFloat(7)
        
        let row1 = yStart + rowHeight
        let row2 = yStart + rowHeight * CGFloat(2)
        let row3 = yStart + rowHeight * CGFloat(3)
        let row4 = yStart + rowHeight * CGFloat(4)
        let row5 = yStart + rowHeight * CGFloat(5)
        let row6 = yStart + rowHeight * CGFloat(6)
        let row7 = yStart + rowHeight * CGFloat(7)
        
        let col1 = customFrameWidth / CGFloat(7)
        let col2 = customFrameWidth / CGFloat(7) * CGFloat(2)
        let col3 = customFrameWidth / CGFloat(7) * CGFloat(3)
        let col4 = customFrameWidth / CGFloat(7) * CGFloat(4)
        let col5 = customFrameWidth / CGFloat(7) * CGFloat(5)
        let col6 = customFrameWidth / CGFloat(7) * CGFloat(6)
        let col7 = customFrameWidth / CGFloat(7) * CGFloat(7)

        //1-3
        boardPositions.append(CGPoint(x: col3, y: row5))
        boardPositions.append(CGPoint(x: col2, y: row6))
        boardPositions.append(CGPoint(x: col1, y: row7))
        
        //4-6
        boardPositions.append(CGPoint(x: col4, y: row5))
        boardPositions.append(CGPoint(x: col4, y: row6))
        boardPositions.append(CGPoint(x: col4, y: row7))
        
        //7-9
        boardPositions.append(CGPoint(x: col5, y: row5))
        boardPositions.append(CGPoint(x: col6, y: row6))
        boardPositions.append(CGPoint(x: col7, y: row7))
        
        //10-12
        boardPositions.append(CGPoint(x: col5, y: row4))
        boardPositions.append(CGPoint(x: col6, y: row4))
        boardPositions.append(CGPoint(x: col7, y: row4))
        
        //13-15
        boardPositions.append(CGPoint(x: col5, y: row3))
        boardPositions.append(CGPoint(x: col6, y: row2))
        boardPositions.append(CGPoint(x: col7, y: row1))
        
        //16-18
        boardPositions.append(CGPoint(x: col4, y: row3))
        boardPositions.append(CGPoint(x: col4, y: row2))
        boardPositions.append(CGPoint(x: col4, y: row1))
        
        //19-21
        boardPositions.append(CGPoint(x: col3, y: row3))
        boardPositions.append(CGPoint(x: col2, y: row2))
        boardPositions.append(CGPoint(x: col1, y: row1))
        
        //22-24
        boardPositions.append(CGPoint(x: col3, y: row4))
        boardPositions.append(CGPoint(x: col2, y: row4))
        boardPositions.append(CGPoint(x: col1, y: row4))
        
        for position in boardPositions {
            let dotSprite = SKSpriteNode(color: UIColor.blackColor(), size: dotSize)
            dotSprite.position = position
            boardPositionSprites.append(dotSprite)
            self.addChild(dotSprite)
        }
    }
    
    func setupCheckers() {
        let checkerSize = CGSize(width: CGFloat(25.0), height: CGFloat(25.0))
        let customFrameWidth = size.width * widthFactor
        let customFrameHeight = size.height * heightFactor
        let yStart = customFrameHeight / CGFloat(7)
        
        //BLUE
        let blueRow = customFrameHeight / CGFloat(8)
        for i in Range(start: 0, end: 9) {
            let checkerSprite = SKSpriteNode(color: UIColor.blueColor(), size: checkerSize)
            checkerSprite.position = CGPoint(x: customFrameWidth / CGFloat(9) * CGFloat(i + 1), y: blueRow)
            blueCheckers.append(checkerSprite)
            self.addChild(checkerSprite)
        }
        
        //RED
        let redRow = yStart + customFrameHeight / CGFloat(7) * CGFloat(8)
        for i in Range(start: 0, end: 9) {
            let checkerSprite = SKSpriteNode(color: UIColor.redColor(), size: checkerSize)
            checkerSprite.position = CGPoint(x: customFrameWidth / CGFloat(9) * CGFloat(i + 1), y: redRow)
            redCheckers.append(checkerSprite)
            self.addChild(checkerSprite)
        }
    }

}
