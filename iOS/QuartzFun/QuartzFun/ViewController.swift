//
//  ViewController.swift
//  QuartzFun
//
//  Created by 陈希 on 2021/9/4.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorController: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeColor(_ sender: UISegmentedControl) {
        let drawingCrolorSelection = DrawingColor(rawValue: UInt(sender.selectedSegmentIndex))
        if let drawingColor = drawingCrolorSelection {
            let funView = view as! QuartzFunView
            switch drawingColor {
            case .Red:
                funView.currentColor = UIColor.red
                funView.useRandomColor = false
            case .Blue:
                funView.currentColor = UIColor.blue
                funView.useRandomColor = false
            case .Yellow:
                funView.currentColor = UIColor.yellow
                funView.useRandomColor = false
            case .Green:
                funView.currentColor = UIColor.green
                funView.useRandomColor = false
            case .Random:
                funView.useRandomColor = true
            }
        }
    }
    
    @IBAction func changeShape(_ sender: UISegmentedControl) {
        let shapeSelection = Shape(rawValue: UInt(sender.selectedSegmentIndex))
        if let shape = shapeSelection {
            let funView = view as! QuartzFunView
            funView.shape = shape
            colorController.isHidden = (shape == Shape.Image)
        }
    }
    
}

