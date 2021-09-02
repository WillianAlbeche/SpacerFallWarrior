//
//  GameScene.swift
//  SpaceFall
//
//  Created by Willian Magnum Albeche on 31/08/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        static let enemy: UInt32 = 1
        static let bullet: UInt32 = 2
        static let player: UInt32 = 3
    }
    
    var player = SKSpriteNode()
    var motionManager = CMMotionManager()
    var destX: CGFloat  = 0.0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        createMainCaracter()
//        if motionManager.isAccelerometerAvailable {
//                    // 2
//                    motionManager.accelerometerUpdateInterval = 0.01
//                    motionManager.startAccelerometerUpdates(to: .main) {
//                        (data, error) in
//                        guard let data = data, error == nil else {
//                            return
//                        }
//
//                        // 3
//                        let currentX = self.player.position.x
//                        self.destX = currentX + CGFloat(data.acceleration.x * 500)
//                    }
//                }
        
        
        var enemyTimeSpawn = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("createEnemyCaracter"), userInfo: nil, repeats: true)
        var bulletsTimeSpawn = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: Selector("spawnBullets"), userInfo: nil, repeats: true)
        
       
        
    }

//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches{
//            let location = touch.location(in: self)
//            player.run(SKAction.moveTo(x: location.x, duration: 0))
//        }
//    }
    
    // MARK: - Player
    func createMainCaracter(){
        player = SKSpriteNode(imageNamed: "MainCaracter")
        // MARK: - Position
        let playerPosition = CGPoint(x: ((self.scene?.size.width)!/2) * 0, y: -(self.size.height)/3)
        player.position = playerPosition
        // MARK: - Physics of player
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        player.physicsBody?.isDynamic = false
        
        
        
        addChild(player)
    }
    
    // MARK: - Enemy
    @objc func createEnemyCaracter(){
        let enemy = SKSpriteNode(imageNamed: "Enemy")
        enemy.name = "enemy"
        // MARK: - Position
        let xPos = randomBeweenNumbers(firstNumber: 0, secondNumber: frame.width)
        enemy.position = CGPoint(x: xPos - 500, y: self.frame.size.height / 2)
        enemy.zPosition = 1
        
        // MARK: - Physics of enemy
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.player
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.isDynamic = true
        //let actionKill =  SKAction.removeFromParent()
        
        // MARK: - Actions
        let moveDown = SKAction.moveTo(y: -(self.frame.size.height / 2), duration: 4)
        enemy.run(moveDown) {
            enemy.removeFromParent()
        }
        addChild(enemy)
    }
    // generating random numbers
    func randomBeweenNumbers(firstNumber: CGFloat , secondNumber: CGFloat   ) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
    }
    
    // MARK: - Bullet
    @objc func spawnBullets(){
        let bullet = SKSpriteNode(imageNamed: "Bullet")
        bullet.name = "bullet"
        
        // MARK: - Position
        bullet.zPosition = -5
        bullet.position = CGPoint(x: player.position.x, y: player.position.y)
        
        // MARK: - Physics of bullets
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = false
        
        // MARK: - Actions
        let outOfScreen = SKAction.removeFromParent()
        let fire = SKAction.moveTo(y: self.size.height + 30, duration: 1)
//        bullet.run(SKAction.repeatForever(fire))
//        bullet.run(SKAction.sequence([fire, outOfScreen]))
        bullet.run(fire) {
            bullet.removeFromParent()
        }
        addChild(bullet)
    }
    
    
    

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        let action = SKAction.moveTo(x: destX, duration: 1)
//                player.run(action)
    }
}
