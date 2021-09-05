//
//  GameScene.swift
//  TextShooter
//
//  Created by 陈希 on 2021/9/4.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var levelNumber: UInt
    private var playerLives: Int {
        didSet {
            let lives = childNode(withName: "LivesLabel") as! SKLabelNode
            lives.text = "Lives: \(playerLives)"
        }
    }
    private var finished = false
    private let playerNode: PlayerNode = PlayerNode()
    private let enemies = SKNode()
    private let playerBullets = SKNode()
    private let forceFields = SKNode()
    
    class func scene(size: CGSize, levelNumber: UInt) -> GameScene {
        return GameScene(size: size, levelNumber: levelNumber)
    }
    override convenience init(size: CGSize) {
        self.init(size: size, levelNumber: 1)
    }
    
    init(size: CGSize, levelNumber: UInt) {
        self.levelNumber = levelNumber
        self.playerLives = 5
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let lives = SKLabelNode(fontNamed: "Courier")
        lives.fontSize = 16
        lives.fontColor = SKColor.black
        lives.name = "LivesLabel"
        lives.text = "Lives: \(playerLives)"
        lives.verticalAlignmentMode = .top
        lives.horizontalAlignmentMode = .right
        lives.position = CGPoint(x: frame.size.width, y: frame.size.height)
        addChild(lives)
        
        let level = SKLabelNode(fontNamed: "Courier")
        level.fontSize = 16
        level.fontColor = SKColor.black
        level.name = "levelLabel"
        level.text = "Level: \(levelNumber)"
        level.verticalAlignmentMode = .top
        level.horizontalAlignmentMode = .left
        level.position = CGPoint(x: 0, y: frame.size.height)
        addChild(level)
        
        let sizeFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        playerNode.position = CGPoint(x: sizeFrame.midX, y: sizeFrame.height * 0.1)
        addChild(playerNode)
        
        addChild(enemies)
        spawnEnemies()
        
        addChild(playerBullets)
        
        addChild(forceFields)
        createForceFields()
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        physicsWorld.contactDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        levelNumber = UInt(aDecoder.decodeInteger(forKey: "level"))
        playerLives = Int(aDecoder.decodeInteger(forKey: "playerLives"))
        super.init(coder: aDecoder)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encodeCInt(Int32(levelNumber), forKey:"level")
        coder.encodeCInt(Int32(playerLives), forKey: "playerLives")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.y < frame.height * 0.2 {
                let target = CGPoint(x: location.x, y: playerNode.position.y)
                playerNode.moveToward(location: target)
            } else {
                let bullet = BulletNode.bullet(from: playerNode.position, toward: location)
                playerBullets.addChild(bullet)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if finished {
            return
        }
        updateBullets()
        updateEnemies()
        if !checkForGameOver() {
            checkForNextLevel()
        }
    }
    
    private func updateBullets() {
        var bulletsToRemove:[BulletNode] = []
        for bullet in playerBullets.children as! [BulletNode] {
            // 清除所有移动到屏幕之外的导弹
            if !frame.contains(bullet.position) {
                bulletsToRemove.append(bullet)
                continue
            }
            
            // 将推力作用于剩下的导弹
            bullet.applyRecurringForce()
        }
        playerBullets.removeChildren(in: bulletsToRemove)
    }
}

// MARK: Next Level
extension GameScene {
    private func checkForNextLevel() {
        if enemies.children.isEmpty {
            goToNextLevel()
        }
    }
    
    private func goToNextLevel() {
        finished = true
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.text = "Level Complete!"
        label.fontColor = SKColor.blue
        label.fontSize = 32
        label.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        addChild(label)
        
        let nextLevel = GameScene(size: frame.size, levelNumber: levelNumber + 1)
        nextLevel.playerLives = playerLives
        view!.presentScene(nextLevel, transition: SKTransition.flipHorizontal(withDuration: 1.0))
    }
}

// MARK: - Game Over
extension GameScene {
    private func checkForGameOver() -> Bool {
        if playerLives == 0 {
            triggerGameOver()
            return true
        }
        return false
    }
    
    private func triggerGameOver() {
        finished = true
        
        do {
            let path = Bundle.main.path(forResource: "EnemyExplosion", ofType: "sks")!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let explosion = try NSKeyedUnarchiver.unarchivedObject(ofClass: SKEmitterNode.self, from: data)!
            explosion.numParticlesToEmit = 200
            explosion.position = playerNode.position
            scene!.addChild(explosion)
            
            let transition = SKTransition.doorsOpenVertical(withDuration: 1)
            let gameOver = GameOverScene(size: frame.size)
            view!.presentScene(gameOver, transition: transition)
        } catch {
            print(error)
        }
    }
}

extension GameScene {
    private func createForceFields() {
        let fieldCount = 3
        let size = frame.size
        let sectionWith = Int(size.width) / fieldCount
        for i in 0..<fieldCount {
            let x = CGFloat(i * sectionWith) + CGFloat(arc4random_uniform(UInt32(sectionWith)))
            let y = CGFloat(arc4random_uniform(UInt32(size.height * 0.25)) + UInt32(size.height * 0.25))
            let gravityField = SKFieldNode.radialGravityField()
            gravityField.position = CGPoint(x: x, y: y)
            gravityField.categoryBitMask = GravityFieldCatetory
            gravityField.strength = 4
            gravityField.falloff = 2
            gravityField.region = SKRegion(size: CGSize(width: size.width * 0.3, height: size.height * 0.1))
            forceFields.addChild(gravityField)
            
            let fieldLocationNode = SKLabelNode(fontNamed: "Courier")
            fieldLocationNode.fontSize = 16
            fieldLocationNode.fontColor = SKColor.red
            fieldLocationNode.name = "GravityField"
            fieldLocationNode.text = "🌏"
            fieldLocationNode.position = CGPoint(x: x, y: y)
            forceFields.addChild(fieldLocationNode)
        }
    }
}

// MARK: - Enemy
extension GameScene {
    private func updateEnemies() {
        var enemiesToRemove: [EnemyNode] = []
        for node in enemies.children as! [EnemyNode] {
            if !frame.contains(node.position) {
                enemiesToRemove.append(node)
                continue
            }
        }
        enemies.removeChildren(in: enemiesToRemove)
    }
    
    private func spawnEnemies() {
        let count = UInt(log(Float(levelNumber))) + levelNumber
        for _ in 0..<count {
            let enemy = EnemyNode()
            let size = frame.size
            let x = arc4random_uniform(UInt32(size.width * 0.8)) + UInt32(size.width * 0.1)
            let y = arc4random_uniform(UInt32(size.height * 0.5)) + UInt32(size.height * 0.5)
            enemy.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
            enemies.addChild(enemy)
        }
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask {
            // 两种物理对象属于同一物理类别
            let nodeA = contact.bodyA.node!
            let nodeB = contact.bodyB.node!
            
            nodeA.friendlyBumpFrom(node: nodeB)
            nodeB.friendlyBumpFrom(node: nodeA)
        } else {
            var attacker: SKNode
            var attackee: SKNode
            
            if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
                // Body A 正在进攻 Body B
                attacker = contact.bodyA.node!
                attackee = contact.bodyB.node!
            } else {
                attacker = contact.bodyB.node!
                attackee = contact.bodyA.node!
            }
            
            if attackee is PlayerNode {
                playerLives -= 1
            }
            
            attackee.receiveAttacker(attacker: attacker, contact: contact)
            playerBullets.removeChildren(in: [attacker])
            enemies.removeChildren(in: [attacker])
        }
    }
}
