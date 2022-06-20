//
//  WarpFilter.swift
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/20.
//

import CoreImage

class WarpFilter: CIFilter {
    var inputImage: CIImage?
    
    static var kernel: CIWarpKernel = { () -> CIWarpKernel in
        guard let url = Bundle.main.url(forResource: "WarpFilterKernel.ci", withExtension: "metallib"),
              let data = try? Data(contentsOf: url) else {
                  fatalError("Unable to load metallib")
              }
        
        guard let kernel = try? CIWarpKernel(functionName: "warpFilter", fromMetalLibraryData: data) else {
            fatalError("Unable to create warp kernel")
        }
        
        return kernel
    }()
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }
        
        return WarpFilter.kernel.apply(
            extent: inputImage.extent,
            roiCallback: { _, rect in
                return rect
            },
            image: inputImage,
            arguments: []
        )
    }
}
