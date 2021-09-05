//
//  EnemyNode.swift
//  TextShooter
//
//  Created by 陈希 on 2021/9/5.
//

import UIKit
import SpriteKit

class EnemyNode: SKNode {
    
    override init() {
        super.init()
        name = "Enemy \(self)"
        initNodeGraph()
        initPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initNodeGraph() {
        let topRow = SKLabelNode(fontNamed: "Courier-Bold")
        topRow.fontColor = SKColor.brown
        topRow.fontSize = 20
        topRow.text = "x x"
        topRow.position = CGPoint(x: 0, y: 15)
        addChild(topRow)
        
        let middleRow = SKLabelNode(fontNamed: "Courier-Bold")
        middleRow.fontColor = SKColor.brown
        middleRow.fontSize = 20
        middleRow.text = "x"
        addChild(middleRow)
        
        let bottomRow = SKLabelNode(fontNamed: "Courier-Bold")
        bottomRow.fontColor = SKColor.brown
        bottomRow.fontSize = 20
        bottomRow.text = "x x"
        bottomRow.position = CGPoint(x: 0, y: -15)
        addChild(bottomRow)
        
    }
    
    private func initPhysicsBody() {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        body.affectedByGravity = false
        body.categoryBitMask = EnemyCatetory
        body.contactTestBitMask = PlayerCatetory | EnemyCatetory
        body.mass = 0.2
        body.angularDamping = 0
        body.linearDamping = 0
        body.fieldBitMask = 0
        
        physicsBody = body
    }
}

extension EnemyNode {
    override func friendlyBumpFrom(node: SKNode) {
        physicsBody!.affectedByGravity = true
    }
    
    override func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact) {
        physicsBody!.affectedByGravity = true
        let force = vectorMultiply(v: physicsBody!.velocity, m: contact.collisionImpulse)
        let myContact = scene!.convertPoint(toView: contact.contactPoint)
        physicsBody!.applyForce(force, at: myContact)
        
        
        do {
            let path = Bundle.main.path(forResource: "MissileExplosion", ofType: "sks")!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let explosion = try NSKeyedUnarchiver.unarchivedObject(ofClass: SKEmitterNode.self, from: data)!
            
            explosion.numParticlesToEmit = 20
            explosion.position = contact.contactPoint
            scene!.addChild(explosion)
        } catch {
            print(error)
        }
    }
}
