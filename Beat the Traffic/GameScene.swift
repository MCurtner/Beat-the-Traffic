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
    case Coins
    case Cars
    case PlayerCar
}

struct PhysicsCategory {
    static let Coin: UInt32 = 1
    static let Car: UInt32 = 2
    static let PlayerCar: UInt32 = 3
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Cars
    let car = SKSpriteNode(imageNamed: "Audi")
    var car1 = SKSpriteNode(imageNamed: "Car")
    var car2 = SKSpriteNode(imageNamed: "Car")
    var car3 = SKSpriteNode(imageNamed: "Car")
    var car4 = SKSpriteNode(imageNamed: "Car")
    
    // Speed at which cars are moving down
    var kDownwardSpeed: CGFloat = 3.0
    
    // Cars
    let vehicleImageArray = ["Mini_truck","Car", "taxi"]
    var carSpriteArray: Array<SKSpriteNode> = []
    
    // Coin Textures
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    var mainCoin = SKSpriteNode()
    

    override func didMoveToView(view: SKView) {
        
        // We implement SKPhysicsContactDelegate to get called back when a contact occurs
        // Register ourself as the delegate
        self.physicsWorld.contactDelegate = self;
        
        // Add the coin images from the texture atlas
        addImagesToArrayFromTextureAtlas()
//
//        // Setup cars
//        setupCarsArray()
//        
//        // Create and add the UI Elements
        createBackground()
        createRoad()
        createPlayerCar()
//
//        // Add the total number of cars to the View
////        addCarsToStreet(car1)
////        addCarsToStreet(car2)
////        addCarsToStreet(car3)
////        addCarsToStreet(car4)
        
        // Create the coins
        createCoins()
        createCoins()
    
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("Hello")
    }
    
    func collisionWithCoin(PlayerCar PlayerCar:SKSpriteNode, Coin: SKSpriteNode) {
        mainCoin.removeFromParent()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            // Not allowing the player car to pass the width of the street
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
        
        mainCoin.position.y -= kDownwardSpeed
        if mainCoin.position.y < -frame.size.height {
            mainCoin.removeFromParent()
            createCoins()
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
        car.zPosition = Layers.PlayerCar.rawValue
        car.name = "playerCar"
        
        car.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 35.0, height: 110))
        car.physicsBody!.affectedByGravity = false
        car.physicsBody!.categoryBitMask = PhysicsCategory.PlayerCar
        car.physicsBody!.contactTestBitMask = PhysicsCategory.Coin
        car.physicsBody!.dynamic = false

        
        self.addChild(car)
    }
    
    
    func addImagesToArrayFromTextureAtlas() {
        textureAtlas = SKTextureAtlas(named: "Coin")
        
        // Sort Array
        for i in 1...textureAtlas.textureNames.count {
            let name = "coin\(i).png"
            textureArray.append(SKTexture(imageNamed: name))
        }
    }
    
    func createCoins() {
        let randomX = getRandomness(zeroToValue: 2)
        let randomY = getRandomness(zeroToValue: frame.size.height * 2)
        
        mainCoin = SKSpriteNode(imageNamed: textureAtlas.textureNames[0])
        mainCoin.size = CGSize(width: 50, height: 50)
        
        if randomX == 0 {
            mainCoin.position = CGPoint(x: frame.size.width/2 - 32, y: randomY + frame.size.height)
        }
        if randomX == 1 {
            mainCoin.position = CGPoint(x: frame.size.width/2 + 32, y: randomY + frame.size.height)
        }
        mainCoin.zPosition = Layers.Coins.rawValue
        mainCoin.name = "coins"
        
        // Coin Physics
        mainCoin.physicsBody = SKPhysicsBody(rectangleOfSize: mainCoin.frame.size)
        mainCoin.physicsBody!.affectedByGravity = false
        mainCoin.physicsBody!.categoryBitMask = PhysicsCategory.Coin
        mainCoin.physicsBody!.contactTestBitMask = PhysicsCategory.PlayerCar
        mainCoin.physicsBody!.dynamic = true
        addChild(mainCoin)
        
        //mainCoin.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textureArray, timePerFrame: 0.09)))
    }
    

    func setupCarsArray() {
        carSpriteArray.append(car1)
        carSpriteArray.append(car2)
        carSpriteArray.append(car3)
        carSpriteArray.append(car4)
    }
    
    
    func addCarsToStreet(carSprite: SKSpriteNode) {
        let randomX = getRandomness(zeroToValue: 2)
        let randomY = getRandomness(zeroToValue: frame.size.height * 2)
        let randomNum = Int(getRandomness(zeroToValue: 2))
        
        carSprite.texture = SKTexture(imageNamed: vehicleImageArray[randomNum])
        carSprite.size = CGSizeMake(128.0, 128.0)
        carSprite.zPosition = Layers.Cars.rawValue
        
        carSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 35.0, height: 110))
        //carSprite.physicsBody?.categoryBitMask = PhysicsCategory.Car
        //carSprite.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerCar
        carSprite.physicsBody?.affectedByGravity = false
        carSprite.physicsBody?.dynamic = false
        
        // If randomX = 0, place car on the left side
        if randomX == 0 {
            carSprite.position = CGPoint(x:frame.size.width/2 - 33, y: randomY + carSprite.size.height + frame.size.height)
        }
        // If randomX = 1, place car on the right side
        if randomX == 1 {
            carSprite.position = CGPoint(x:frame.size.width/2 + 33, y: randomY + carSprite.size.height + frame.size.height)
        }
        
        carSprite.name = "regularCars"
        addChild(carSprite)
    }
    
    
    // Return the random value between 0 and the provided parameter
    func getRandomness(zeroToValue zeroToValue: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(zeroToValue)))
    }
}







