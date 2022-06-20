//
//  BlendFilter.swift
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/20.
//

import CoreImage
import UIKit
import SwiftUI

class BlendFilter: CIFilter {
    let background: CIImage?
    
    init(backgroundImage: UIImage) {
        background = CIImage(image: backgroundImage)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }
        guard let background = background else {
            return nil
        }
        return CIBlendKernel.multiply.apply(foreground: inputImage, background: background)
    }
}
