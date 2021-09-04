//
//  QuartzFunView.swift
//  QuartzFun
//
//  Created by 陈希 on 2021/9/4.
//

import UIKit

enum Shape: UInt {
    case Line = 0, Rect, Ellipse, Image
}

enum DrawingColor: UInt {
    case Red = 0, Blue, Yellow, Green, Random
}

class QuartzFunView: UIView {
    var shape = Shape.Line
    var currentColor = UIColor.red
    var useRandomColor = false
    
    private let image = UIImage(named: "apple")
    private var firstTouchLocation: CGPoint = CGPoint.zero
    private var lastTouchLocation: CGPoint = CGPoint.zero
    private var redrawRect: CGRect = CGRect.zero
}

extension QuartzFunView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if useRandomColor {
            currentColor = UIColor.randomColor()
        }
        let touch = touches.first!
        firstTouchLocation = touch.location(in: self)
        lastTouchLocation = firstTouchLocation
        redrawRect = CGRect.zero
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        lastTouchLocation = touch.location(in: self)
        
        if shape == .Image {
            let horizonalOffset = image!.size.width / 2
            let verticalOffset = image!.size.width / 2
            redrawRect = redrawRect.union(CGRect(x: lastTouchLocation.x - horizonalOffset, y: lastTouchLocation.y - verticalOffset, width: image!.size.width, height: image!.size.height))
        } else {
            redrawRect = redrawRect.union(currentRect())
        }
        
        setNeedsDisplay(redrawRect)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        lastTouchLocation = touch.location(in: self)
        
        if shape == .Image {
            let horizonalOffset = image!.size.width / 2
            let verticalOffset = image!.size.width / 2
            redrawRect = redrawRect.union(CGRect(x: lastTouchLocation.x - horizonalOffset, y: lastTouchLocation.y - verticalOffset, width: image!.size.width, height: image!.size.height))
        } else {
            redrawRect = redrawRect.union(currentRect())
        }
        
        setNeedsDisplay(redrawRect)
    }
    
    func currentRect() -> CGRect {
        return CGRect(x: firstTouchLocation.x, y: firstTouchLocation.y, width: lastTouchLocation.x - firstTouchLocation.x, height: lastTouchLocation.y - firstTouchLocation.y)
    }
}

extension QuartzFunView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(currentColor.cgColor)
        context?.setFillColor(currentColor.cgColor)
                
        switch shape {
        case .Line:
            context?.move(to: firstTouchLocation)
            context?.addLine(to: lastTouchLocation)
            context?.strokePath()
        
        case .Rect:
            context?.addRect(currentRect())
            context?.drawPath(using: .fillStroke)
        
        case .Ellipse:
            context?.addEllipse(in: currentRect())
            context?.drawPath(using: .fillStroke)
            
        case .Image:
            let horizontalOffset = image!.size.width / 2
            let verticalOffset = image!.size.width / 2
            let drawPoint = CGPoint(x: lastTouchLocation.x - horizontalOffset, y: lastTouchLocation.y - verticalOffset)
            image?.draw(at: drawPoint)
            break
        }
    }
}

extension UIColor {
    class func randomColor() -> UIColor {
        let red = CGFloat(Double(arc4random() % 256)/255)
        let green = CGFloat(Double(arc4random() % 256)/255)
        let blue = CGFloat(Double(arc4random() % 256)/255)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
