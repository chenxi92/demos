//
//  PlayerNode.swift
//  TextShooter
//
//  Created by 陈希 on 2021/9/5.
//

import UIKit
import Foundation
import SpriteKit

class PlayerNode: SKNode {
    override init() {
        super.init()
        name = "Player \(self)"
        initNodeGraph()
        initPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initNodeGraph() {
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.darkGray
        label.fontSize = 40
        label.text = "v"
        label.zRotation = CGFloat(Double.pi)
        label.name = "label"
        self.addChild(label)
    }
    
    private func initPhysicsBody() {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        body.affectedByGravity = false
        body.categoryBitMask = PlayerCatetory
        body.contactTestBitMask = EnemyCatetory
        body.collisionBitMask = 0
        body.fieldBitMask = 0
        
        physicsBody = body
    }
}

extension PlayerNode {
    public func moveToward(location: CGPoint) {
        removeAction(forKey: "movement")
        removeAction(forKey: "wobbling")
        
        let distance = pointDistance(p1: position, p2: location)
        let screenWidth = UIScreen.main.bounds.size.width
        let duration = TimeInterval(2 * distance / screenWidth)
        
        run(SKAction.move(to: location, duration: duration), withKey: "movement")
        
        let wobbleTime = 0.3
        let halfWobbleTime = wobbleTime / 2
        let wobbling = SKAction.sequence([
            SKAction.scaleX(to: 0.2, duration: halfWobbleTime),
            SKAction.scaleX(to: 1.0, duration: halfWobbleTime)
        ])
        let wobbleCount = Int(duration/wobbleTime)
        run(SKAction.repeat(wobbling, count: wobbleCount), withKey: "wobbling")
    }
}
