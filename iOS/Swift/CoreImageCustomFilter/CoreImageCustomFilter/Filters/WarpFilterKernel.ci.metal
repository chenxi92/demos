//
//  WarpFilterKernel.ci.metal.metal
//  CoreImageCustomFilter
//
//  Created by peak on 2022/6/20.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" {
    namespace coreimage {
        float2 warpFilter(destination dest) {
            float y = dest.coord().y + tan(dest.coord().y / 10) * 20;
            float x = dest.coord().x + tan(dest.coord().x / 10) * 20;
            return float2(x, y);
        }
    }
}
