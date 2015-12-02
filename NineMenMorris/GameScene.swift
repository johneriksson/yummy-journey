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
    let menuScene = MenuScene()
    let endScene = EndScene()
    var shouldInitialize = true
    
    var boardPositions = Array<CGPoint>()
    var boardPositionSprites = Array<SKSpriteNode>()
    
    var blueCheckers = Array<SKSpriteNode>()
    var redCheckers = Array<SKSpriteNode>()
    
    let widthFactor = CGFloat(0.87)
    let heightFactor = CGFloat(0.6)
    
    var checkerCurrentlyMoving: SKSpriteNode!
    var checkerCurrentlyMovingOriginalColor: UIColor!
    var colorMoving = 0
    
    var turnLabel: SKLabelNode!
    var removeLabel: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        if shouldInitialize {
            brain.reset()
            self.backgroundColor = UIColor.whiteColor()
            
            menuScene.setReturnScene(self)
            menuScene.scaleMode = .ResizeFill
            
            clearOld()
            setupBoardPositions()
            setupCheckers()
            setupTopSection()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let label = self.nodeAtPoint(location) as? SKLabelNode {
                if label.name == "Menu Button" {
                    handleMenuButtonTouch()
                }
            }
            if let sprite = self.nodeAtPoint(location) as? SKSpriteNode {
                handleSpriteTouch(sprite)
            }
        }
    }
    
    func handleMenuButtonTouch() {
        let transition = SKTransition.revealWithDirection(.Up, duration: 1.0)

        scene?.view?.presentScene(menuScene, transition: transition)
    }
    
    func showEndScene() {
        let transition = SKTransition.revealWithDirection(.Right, duration: 1.0)
        
        endScene.scaleMode = .ResizeFill
        
        scene?.view?.presentScene(endScene, transition: transition)
    }
    
    func handleSpriteTouch(sprite: SKSpriteNode) {
        if blueCheckers.contains(sprite) {
            colorMoving = 1
            setCheckerCurrentlyMoving(sprite)
        } else if redCheckers.contains(sprite) {
            colorMoving = 2
            setCheckerCurrentlyMoving(sprite)
        } else if boardPositionSprites.contains(sprite) && checkerCurrentlyMoving != nil {
            if let to = boardPositionSprites.indexOf(sprite) {
                var from: Int {
                    if let index = boardPositions.indexOf(checkerCurrentlyMoving.position) {
                        return index
                    }
                    
                    return -1
                }
                if brain.legalMove(to, from: from, color: colorMoving) {
                    checkerCurrentlyMoving.position = sprite.position
                    printTurnLabel()
                }
            }
            
            setCheckerCurrentlyMoving(nil)
        }
    }
    
    @nonobjc func setCheckerCurrentlyMoving(sprite: SKSpriteNode?) {
        if checkerCurrentlyMoving != nil {
            checkerCurrentlyMoving.color = checkerCurrentlyMovingOriginalColor
        }
        
        if sprite != nil {
            checkerCurrentlyMoving = sprite
            checkerCurrentlyMovingOriginalColor = sprite!.color
            checkerCurrentlyMoving.color = UIColor.greenColor()
        } else {
            checkerCurrentlyMoving = nil
            checkerCurrentlyMovingOriginalColor = nil
        }
    }
    
    func printTurnLabel() {
        let turnLabel = SKLabelNode()
        
        if colorMoving == 1{
            turnLabel.text = "Red's turn"
            turnLabel.text = "Red's turn"
        } else {
            turnLabel.text = "Blue's turn"
            turnLabel.text = "Blue's turn"
        }

        let scale = SKAction.scaleTo(2.5, duration: 0.5)
        let fade = SKAction.fadeOutWithDuration(0.5)
        
        turnLabel.fontName = "HelveticaNeue-Bold"
        turnLabel.fontSize = 35
        turnLabel.fontColor = UIColor.blackColor()
        turnLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        turnLabel.zPosition = CGFloat(15)
        
        self.addChild(turnLabel)
        
        let sequence = SKAction.sequence([scale, fade])
        turnLabel.runAction(sequence)
    }
    
    func updateRemoveLabel(remove: Bool) {
        if remove {
            removeLabel.text = "Remove"
        } else {
            removeLabel.text = ""
        }
    }
    
    func clearOld() {
        let children = self.children
        for child in children {
            child.removeFromParent()
        }
        
        boardPositions.removeAll()
        boardPositionSprites.removeAll()
        blueCheckers.removeAll()
        redCheckers.removeAll()
    }
    
    func setupBoardPositions() {
        let customFrameWidth = size.width * widthFactor
        let customFrameHeight = size.height * heightFactor
        let rowHeight = customFrameHeight / CGFloat(7)
        let yStart = customFrameHeight / CGFloat(7)
        
        let row1 = ceil(yStart + rowHeight)
        let row2 = ceil(yStart + rowHeight * CGFloat(2))
        let row3 = ceil(yStart + rowHeight * CGFloat(3))
        let row4 = ceil(yStart + rowHeight * CGFloat(4))
        let row5 = ceil(yStart + rowHeight * CGFloat(5))
        let row6 = ceil(yStart + rowHeight * CGFloat(6))
        let row7 = ceil(yStart + rowHeight * CGFloat(7))
        
        let col1 = ceil(customFrameWidth / CGFloat(7))
        let col2 = ceil(customFrameWidth / CGFloat(7) * CGFloat(2))
        let col3 = ceil(customFrameWidth / CGFloat(7) * CGFloat(3))
        let col4 = ceil(customFrameWidth / CGFloat(7) * CGFloat(4))
        let col5 = ceil(customFrameWidth / CGFloat(7) * CGFloat(5))
        let col6 = ceil(customFrameWidth / CGFloat(7) * CGFloat(6))
        let col7 = ceil(customFrameWidth / CGFloat(7) * CGFloat(7))
        
        //0-2
        boardPositions.append(CGPoint(x: col3, y: row5))
        boardPositions.append(CGPoint(x: col2, y: row6))
        boardPositions.append(CGPoint(x: col1, y: row7))
        
        //3-5
        boardPositions.append(CGPoint(x: col4, y: row5))
        boardPositions.append(CGPoint(x: col4, y: row6))
        boardPositions.append(CGPoint(x: col4, y: row7))
        
        //6-8
        boardPositions.append(CGPoint(x: col5, y: row5))
        boardPositions.append(CGPoint(x: col6, y: row6))
        boardPositions.append(CGPoint(x: col7, y: row7))
        
        //9-11
        boardPositions.append(CGPoint(x: col5, y: row4))
        boardPositions.append(CGPoint(x: col6, y: row4))
        boardPositions.append(CGPoint(x: col7, y: row4))
        
        //12-14
        boardPositions.append(CGPoint(x: col5, y: row3))
        boardPositions.append(CGPoint(x: col6, y: row2))
        boardPositions.append(CGPoint(x: col7, y: row1))
        
        //15-17
        boardPositions.append(CGPoint(x: col4, y: row3))
        boardPositions.append(CGPoint(x: col4, y: row2))
        boardPositions.append(CGPoint(x: col4, y: row1))
        
        //18-20
        boardPositions.append(CGPoint(x: col3, y: row3))
        boardPositions.append(CGPoint(x: col2, y: row2))
        boardPositions.append(CGPoint(x: col1, y: row1))
        
        //21-23
        boardPositions.append(CGPoint(x: col3, y: row4))
        boardPositions.append(CGPoint(x: col2, y: row4))
        boardPositions.append(CGPoint(x: col1, y: row4))
        
        for position in boardPositions {
            let dotSprite = SKSpriteNode(imageNamed: "dotSprite.png")
            dotSprite.position = position
            dotSprite.zPosition = CGFloat(5)
            boardPositionSprites.append(dotSprite)
            self.addChild(dotSprite)
        }
    }
    
    func setupCheckers() {
        let checkerSize = CGSize(width: CGFloat(25.0), height: CGFloat(25.0))
        let customFrameWidth = size.width * widthFactor
        let customFrameHeight = size.height * heightFactor
        let yStart = customFrameHeight / CGFloat(7)
        let checkerZPosition = CGFloat(10)
        
        //BLUE
        let blueRow = customFrameHeight / CGFloat(8)
        for i in Range(start: 0, end: 9) {
            let checkerSprite = SKSpriteNode(color: UIColor.blueColor(), size: checkerSize)
            checkerSprite.position = CGPoint(x: customFrameWidth / CGFloat(9) * CGFloat(i + 1), y: blueRow)
            checkerSprite.zPosition = checkerZPosition
            blueCheckers.append(checkerSprite)
            self.addChild(checkerSprite)
        }
        
        //RED
        let redRow = yStart + customFrameHeight / CGFloat(7) * CGFloat(8)
        for i in Range(start: 0, end: 9) {
            let checkerSprite = SKSpriteNode(color: UIColor.redColor(), size: checkerSize)
            checkerSprite.position = CGPoint(x: customFrameWidth / CGFloat(9) * CGFloat(i + 1), y: redRow)
            checkerSprite.zPosition = checkerZPosition
            redCheckers.append(checkerSprite)
            self.addChild(checkerSprite)
        }
    }
    
    func setupTopSection() {
        let customFrameWidth = size.width * widthFactor
        let topSectionY = size.height - CGFloat(50)
        
        turnLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        turnLabel.text = "Red's turn"
        turnLabel.name = "Status Label"
        turnLabel.fontSize = CGFloat(20)
        turnLabel.position = CGPoint(x: customFrameWidth / CGFloat(4), y: topSectionY)
        turnLabel.fontColor = UIColor.blackColor()
        self.addChild(turnLabel)
        
        removeLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        removeLabel.text = ""
        removeLabel.name = "Remove Label"
        removeLabel.fontSize = CGFloat(20)
        removeLabel.position = CGPoint(x: customFrameWidth / CGFloat(4), y: topSectionY - 50)
        removeLabel.fontColor = UIColor.blackColor()
        self.addChild(removeLabel)
        
        let button = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        button.text = "Menu"
        button.name = "Menu Button"
        button.fontSize = CGFloat(20)
        button.position = CGPoint(x: size.width - customFrameWidth / CGFloat(4), y: topSectionY)
        button.fontColor = UIColor(red: CGFloat(0.4), green: CGFloat(0.4), blue: CGFloat(0.6), alpha: CGFloat(1.0))
        self.addChild(button)
    }

}
