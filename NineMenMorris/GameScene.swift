//
//  GameScene.swift
//  NineMenMorris
//
//  Created by John Eriksson on 2015-11-24.
//  Copyright (c) 2015 John Eriksson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //Scenes & setup
    let brain = NineMenMorrisRules()
    let menuScene = MenuScene()
    let endScene = EndScene()
    var shouldInitialize = true
    
    //Sprites & positions
    var boardPositions = Array<CGPoint>()
    var boardPositionSprites = Array<SKSpriteNode>()
    var blueCheckers = Array<SKSpriteNode>()
    var redCheckers = Array<SKSpriteNode>()
    
    //Custom frame size
    let widthFactor = CGFloat(0.87)
    let heightFactor = CGFloat(0.6)
    
    //Moving status
    var checkerCurrentlyMoving: SKSpriteNode!
    var checkerCurrentlyMovingOriginalColor: UIColor!
    var colorMoving = 0
    var removing = false
    
    //Labels
    var turnLabel: SKLabelNode!
    var removeLabel: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        //Initialize if user pressed restart. Otherwise no dothing and continue old game
        if shouldInitialize {
            brain.reset()
            self.backgroundColor = UIColor.whiteColor()
            
            menuScene.setReturnScene(self)
            
            clearOld()
            setupBoardPositions()
            setupCheckers()
            setupTopSection()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            //Menu button touch
            if let label = self.nodeAtPoint(location) as? SKLabelNode {
                if label.name == "Menu Button" {
                    handleMenuButtonTouch()
                }
            }
            
            //Sprite touch
            if let sprite = self.nodeAtPoint(location) as? SKSpriteNode {
                handleSpriteTouch(sprite)
            }
        }
    }
    
    //Transition to MenuScene
    func handleMenuButtonTouch() {
        let transition = SKTransition.revealWithDirection(.Up, duration: 1.0)

        menuScene.scaleMode = .ResizeFill
        
        scene?.view?.presentScene(menuScene, transition: transition)
    }
    
    //Transition to EndScene
    func showEndScene() {
        let transition = SKTransition.revealWithDirection(.Right, duration: 1.0)
        
        endScene.scaleMode = .ResizeFill
        
        if colorMoving == 1 {
            endScene.winner = "BLUE"
        } else {
            endScene.winner = "RED"
        }
        
        scene?.view?.presentScene(endScene, transition: transition)
    }
    
    func handleSpriteTouch(sprite: SKSpriteNode) {
        if blueCheckers.contains(sprite) {
            removeOrMarkChecker(sprite, color: "BLUE")
        } else if redCheckers.contains(sprite) {
            removeOrMarkChecker(sprite, color: "RED")
        } else if boardPositionSprites.contains(sprite) && checkerCurrentlyMoving != nil {
            tryToMoveChecker(sprite)
        }
    }
    
    func removeOrMarkChecker(sprite: SKSpriteNode, color: String) {
        var removeColor: Int!
        var winCheck: Int!
        
        if color == "BLUE" {
            removeColor = 4
            winCheck = 5
        } else {
            removeColor = 5
            winCheck = 4
        }
        
        if removing {
            if let pos = boardPositions.indexOf(sprite.position) {
                if brain.remove(pos, color: removeColor) {
                    sprite.removeFromParent()
                    removing = false
                    updateRemoveLabel()
                    updateTurnLabel()
                    
                    if brain.win(winCheck) {
                        showEndScene()
                    }
                    
                }
            }
        } else {
            if color == "BLUE" {
                colorMoving = 1
            } else {
                colorMoving = 2
            }
            setCheckerCurrentlyMoving(sprite)
        }
    }
    
    func tryToMoveChecker(sprite: SKSpriteNode) {
        if let to = boardPositionSprites.indexOf(sprite) {
            var from: Int {
                if let index = boardPositions.indexOf(checkerCurrentlyMoving.position) {
                    return index
                }
                
                return -1
            }
            if brain.legalMove(to, from: from, color: colorMoving) {
                checkerCurrentlyMoving.position = sprite.position
                
                if brain.remove(to) {
                    removing = true
                    updateRemoveLabel()
                } else {
                    updateTurnLabel()
                }
            }
        }
        
        setCheckerCurrentlyMoving(nil)
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
    
    func updateTurnLabel() {
        if colorMoving == 1{
            turnLabel.text = "Red's turn"
        } else {
            turnLabel.text = "Blue's turn"
        }
    }

    func updateRemoveLabel() {
        if removing {
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
