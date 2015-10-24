//
//  GameScene.swift
//  Beat the Traffic
//
//  Created by Matthew Curtner on 10/24/15.
//  Copyright (c) 2015 Matthew Curtner. All rights reserved.
//

import SpriteKit

enum Layers: CGFloat {
    case Background = -1
    case Road
    case RoadLines
    case Cars
}

class GameScene: SKScene {
    
    let car = SKSpriteNode(imageNamed: "Audi")
    var car1 = SKSpriteNode(imageNamed: "Car")
    var car2 = SKSpriteNode(imageNamed: "Car")
    var car3 = SKSpriteNode(imageNamed: "Car")
    var car4 = SKSpriteNode(imageNamed: "Car")
    
    var kDownwardSpeed: CGFloat = 3.0
    
    let vehicleImageArray = ["Mini_truck","Car", "taxi"]
    var carSpriteArray: Array<SKSpriteNode> = []
    
    
    override func didMoveToView(view: SKView) {
        
        carSpriteArray.append(car1)
        carSpriteArray.append(car2)
        carSpriteArray.append(car3)
        carSpriteArray.append(car4)
        
        createBackground()
        createRoad()
        createPlayerCar()
        
        addCarsToStreet(car1)
        addCarsToStreet(car2)
        addCarsToStreet(car3)
        addCarsToStreet(car4)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            // Not allowing the ship to pass a certain height
            if location.x < frame.size.width/2 {
                car.runAction(SKAction.moveToX(frame.size.width/2 - 32, duration: 0.5))
            }
            
            if location.x > frame.size.width/2 {
                car.runAction(SKAction.moveToX(frame.size.width/2 + 32, duration: 0.5))
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        for car in carSpriteArray {
            
            // Downward speed of cars
            car.position.y -= kDownwardSpeed
            
            // If the car is off screen remove it from the parent and create new ones
            if car.position.y < -frame.size.height {
                car.removeFromParent()
                addCarsToStreet(car)
            }
        }
    }
    
    func createBackground() {
        let background = SKSpriteNode(color: SKColor.greenColor(), size: CGSizeMake(frame.size.width, frame.size.height))
        background.zPosition = Layers.Background.rawValue
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(background)
    }
    
    func createRoad() {
        let roadPath = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(128.0, frame.size.height))
        roadPath.position = CGPoint(x:frame.size.width/2, y: frame.size.height/2)
        roadPath.zPosition = Layers.Road.rawValue
        addChild(roadPath)
        
        let centerLines = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(5.0, frame.size.height))
        centerLines.position = CGPoint(x:frame.size.width/2, y: frame.size.height/2)
        centerLines.zPosition = Layers.RoadLines.rawValue
        addChild(centerLines)
    }
    
    func createPlayerCar() {
        car.size = CGSizeMake(128.0, 128.0)
        car.position = CGPoint(x:frame.size.width/2 + 33, y: frame.size.height/2)
        car.zPosition = Layers.Cars.rawValue
        car.name = "playerCar"
        addChild(car)
    }
    
    func addCarsToStreet(carSprite: SKSpriteNode) {
        let randomX = Int(arc4random_uniform(UInt32(2)))
        let randomY = CGFloat(arc4random_uniform(UInt32(frame.size.height * 2)))
        let randomNum = Int(arc4random_uniform(UInt32(2)))
        
        carSprite.texture = SKTexture(imageNamed: vehicleImageArray[randomNum])
        carSprite.size = CGSizeMake(128.0, 128.0)
        
        
        // If randomX = 0, place car on the left side
        if randomX == 0 {
            carSprite.position = CGPoint(x:frame.size.width/2 - 33, y: randomY + carSprite.size.height)
        }
        // If randomX = 1, place car on the right side
        if randomX == 1 {
            carSprite.position = CGPoint(x:frame.size.width/2 + 33, y: randomY + carSprite.size.height)
        }
        
        carSprite.name = "regularCars"
        addChild(carSprite)
    }
}







