//
//  ImageProcessor.swift
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/20.
//

/// https://www.raywenderlich.com/25658084-core-image-tutorial-for-ios-custom-filters

import UIKit
import CoreImage

enum ProcessEffect: String, CaseIterable, Equatable {
    case builtIn
    case colorKernel
    case warpkernel
    case blendKernel
}

class ImageProcessor: ObservableObject {
    static let shared = ImageProcessor()
    let context = CIContext()
    @Published var output: UIImage = .init()
    
    func process(painting: Painting, effect: ProcessEffect) {
        print("\nProcess \(painting.name) with: \(effect.rawValue)\n")
        guard let paintImage = UIImage(named: painting.image), let input = CIImage(image: paintImage) else {
            print("Invalid input image")
            return
        }
        
        switch effect {
        case .builtIn:
            applyBuiltInErrect(input: input)
        case .colorKernel:
            applyColorKernel(input: input)
        case .warpkernel:
            applyWarpKernel(input: input)
        case .blendKernel:
            applyBlenkkernel(input: input)
        }
    }
    
    private func applyBuiltInErrect(input: CIImage) {
        let noir = CIFilter(name: "CIPhotoEffectNoir", parameters: ["inputImage": input])?.outputImage
        
        let sunGenerate = CIFilter(
            name: "CISunbeamsGenerator",
            parameters: [
                "inputStriationStrength": 1,
                "inputSunRadius": 300,
                "inputCenter": CIVector(
                    x: input.extent.width - input.extent.width / 5,
                    y: input.extent.height - input.extent.height / 10)
            ])?.outputImage
        
        let compositeImage = input.applyingFilter(
            "CIBlendWithMask",
            parameters: [
                kCIInputBackgroundImageKey: noir as Any,
                kCIInputMaskImageKey: sunGenerate as Any]
        )
        
        renderAsUIImageIfNeed(compositeImage)
    }
    
    private func applyColorKernel(input: CIImage) {
        let filter = ColorFilter()
        filter.inputImage = input
        if let outputImage = filter.outputImage {
            renderAsUIImageIfNeed(outputImage)
        }
    }
    
    private func applyWarpKernel(input: CIImage) {
        let filter = WarpFilter()
        filter.inputImage = input
        if let outputImage = filter.outputImage {
            renderAsUIImageIfNeed(outputImage)
        }
    }
    
    private func applyBlenkkernel(input: CIImage) {
        guard let backgroundImage = UIImage(named: "multi_color") else {
            return
        }
        let filter = BlendFilter(backgroundImage: backgroundImage)
        filter.inputImage = input
        if let outputImage = filter.outputImage {
            renderAsUIImageIfNeed(outputImage)
        }
    }
    
    private func renderAsUIImageIfNeed(_ image: CIImage) {
        if let cgImage = context.createCGImage(image, from: image.extent) {
            output = UIImage(cgImage: cgImage)
        }
    }
}
