//
//  BulletNode.swift
//  TextShooter
//
//  Created by 陈希 on 2021/9/5.
//

import UIKit
import SpriteKit

class BulletNode: SKNode {
    var thrust: CGVector = CGVector.zero
    
    override init() {
        super.init()
        
        let dot = SKLabelNode(fontNamed: "Courier")
        dot.fontColor = SKColor.black
        dot.fontSize = 40
        dot.text = "."
        addChild(dot)
        
        let body = SKPhysicsBody(circleOfRadius: 1)
        body.isDynamic = true
        body.categoryBitMask = PlayerMissleCategory
        body.contactTestBitMask = EnemyCatetory
        body.collisionBitMask = EnemyCatetory
        body.fieldBitMask = GravityFieldCatetory
        body.mass = 0.01
        
        physicsBody = body
        name = "Bullet \(self)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let dx = CGFloat(aDecoder.decodeFloat(forKey: "thrustX"))
        let dy = CGFloat(aDecoder.decodeFloat(forKey: "thrustY"))
        thrust = CGVector(dx: dx, dy: dy)
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(Float(thrust.dx), forKey: "thrustX")
        coder.encode(Float(thrust.dy), forKey: "thrustY")
    }
}

extension BulletNode {
    class func bullet(from start: CGPoint, toward destination: CGPoint) -> BulletNode {
        let bullet = BulletNode()
        bullet.position = start
        let movement = vectorBetweenPoints(p1: start, p2: destination)
        let magnitude = vectorLength(v: movement)
        let scaledMovement = vectorMultiply(v: movement, m: 1/magnitude)
        
        let thrustMagnitude = CGFloat(100.0)
        bullet.thrust = vectorMultiply(v: scaledMovement, m: thrustMagnitude)
        
        return bullet
    }
    
    func applyRecurringForce() {
        physicsBody!.applyForce(thrust)
    }
}
