//
//  Geometry.swift
//  TextShooter
//
//  Created by 陈希 on 2021/9/5.
//

import Foundation
import UIKit

func vectorMultiply(v: CGVector, m: CGFloat) -> CGVector {
    return CGVector(dx: v.dx * m, dy: v.dy * m)
}

func vectorBetweenPoints(p1: CGPoint, p2: CGPoint) -> CGVector {
    return CGVector(dx: p2.x - p1.x, dy: p2.y - p1.y)
}

func vectorLength(v: CGVector) -> CGFloat {
    return CGFloat(sqrtf(powf(Float(v.dx), 2) + powf(Float(v.dy), 2)))
}

func pointDistance(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return CGFloat(sqrtf(powf(Float(p2.x - p1.x), 2) + powf(Float(p2.y - p1.y), 2)))
}

