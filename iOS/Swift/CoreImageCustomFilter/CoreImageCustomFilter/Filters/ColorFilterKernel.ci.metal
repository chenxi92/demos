//
//  ColorFilterKernel.ci.metal
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/20.
//

#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" {
    namespace coreimage {
        float4 colorFilterKernel(sample_t s) {
            float4 swappedColor;
            swappedColor.r = s.g;
            swappedColor.g = s.b;
            swappedColor.b = s.r;
            swappedColor.a = s.a;
            return swappedColor;
        }
    }
}

