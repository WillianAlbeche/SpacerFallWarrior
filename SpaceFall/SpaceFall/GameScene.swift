//
//  GameScene.swift
//  SpaceFall
//
//  Created by Willian Magnum Albeche on 31/08/21.
//

import SpriteKit
import GameplayKit
//import CoreMotion

struct PhysicsCategory {
    static let enemy: UInt32 = 1
    static let bullet: UInt32 = 2
    static let player: UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var lifes = 4 {
        didSet{
            lifeLabel.text = "Lifes: \(lifes)"
        }
       
    }
    var lifeLabel = SKLabelNode()
    
    var player = SKSpriteNode()
    var scoreLabel = SKLabelNode()

    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        createMainCaracter()
        var enemyTimeSpawn = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector("createEnemyCaracter"), userInfo: nil, repeats: true)
        var bulletsTimeSpawn = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: Selector("spawnBullets"), userInfo: nil, repeats: true)
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: 300, y: 500)
        scoreLabel.horizontalAlignmentMode = .right
        addChild(scoreLabel)
        
        lifeLabel =  SKLabelNode()
        lifeLabel.text = "Lifes: \(lifes)"
        lifeLabel.position = CGPoint(x: -300, y: 500)
        lifeLabel.horizontalAlignmentMode = .left
        addChild(lifeLabel)
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            player.run(SKAction.moveTo(x: location.x, duration: 0))
        }
         
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
       //NSLog("hello", contact)
        
        var firstContact: SKPhysicsBody = contact.bodyA
        var secondContact:SKPhysicsBody = contact.bodyB
        // MARK: - TAVA DEBBUGANDO, SEM JULGAMENTOS
        //print("First: \(firstContact.categoryBitMask)")
        //print("second: \(secondContact.categoryBitMask)")
        
        if((firstContact.categoryBitMask == PhysicsCategory.enemy) && (secondContact.categoryBitMask ==  PhysicsCategory.bullet) || (firstContact.categoryBitMask == PhysicsCategory.bullet) && (secondContact.categoryBitMask ==  PhysicsCategory.enemy) ){
            collisionCheckerBullet(enemy: firstContact.node as! SKSpriteNode, bullet: secondContact.node as! SKSpriteNode)
            score += 1
        }
        else if(firstContact.categoryBitMask == PhysicsCategory.player) && (secondContact.categoryBitMask ==  PhysicsCategory.enemy) || (firstContact.categoryBitMask == PhysicsCategory.enemy) && (secondContact.categoryBitMask ==  PhysicsCategory.player){
            collisionCheckerPlayer(player: firstContact.node as! SKSpriteNode, enemy: secondContact.node as! SKSpriteNode)
            if(lifes == 0){
                player.removeFromParent()
            }
            else{
                lifes -= 1
            }
            
        }
    }
    
    func collisionCheckerBullet(enemy:SKSpriteNode,  bullet:SKSpriteNode){
        enemy.removeFromParent()
        bullet.removeFromParent()
    }
    func collisionCheckerPlayer(player: SKSpriteNode, enemy:SKSpriteNode){
        enemy.removeFromParent()
        
    }
    
     
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
        enemy.position = CGPoint(x: xPos - 500 , y: self.frame.size.height / 2)
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
        let moveDown = SKAction.moveTo(y: -(self.frame.size.height / 2), duration: 2)
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
        bullet.physicsBody?.restitution = 0.4
        
        // MARK: - Actions
        //let outOfScreen = SKAction.removeFromParent()
        let fire = SKAction.moveTo(y: self.size.height + 30, duration: 1)
        bullet.run(fire) {
            bullet.removeFromParent()
        }
        addChild(bullet)
    }
//    @objc func spawnEnemyBullets(){
//        let bullet = SKSpriteNode(imageNamed: "Bullet")
//        bullet.name = "bullet"
//
//        // MARK: - Position
//        bullet.zPosition = -5
//        bullet.position = CGPoint(x: enemy.position.x, y: enemy.position.y)
//
//        // MARK: - Physics of bullets
//        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
//        bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
//        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.player
//        bullet.physicsBody?.affectedByGravity = false
//        bullet.physicsBody?.isDynamic = false
//        bullet.physicsBody?.restitution = 0.4
//
//        // MARK: - Actions
//        let outOfScreen = SKAction.removeFromParent()
//        let fire = SKAction.moveTo(y: self.size.height + 30, duration: 1)
//        bullet.run(fire) {
//            bullet.removeFromParent()
//        }
//        addChild(bullet)
//    }
    

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        let action = SKAction.moveTo(x: destX, duration: 1)
//                player.run(action)
        
    }
}
