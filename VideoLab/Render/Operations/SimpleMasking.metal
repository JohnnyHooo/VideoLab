#include <metal_stdlib>
#include "OperationShaderTypes.h"

using namespace metal;

fragment half4 simpleMasking(TwoInputVertexIO fragmentInput [[stage_in]],
                          texture2d<half> inputTexture [[texture(0)]],
                          texture2d<half> maskTexture [[texture(1)]],
                          constant float& mode [[buffer(1)]],
                          constant float& backgroundAlpha [[buffer(2)]]) {
    constexpr sampler texturesampler(mag_filter::linear, min_filter::linear);
    //    constexpr sampler quadSampler;

    // Use same coordinate for both textures since flip is fixed in PersonSegmentationOperation
    float2 textureCoordinate = fragmentInput.textureCoordinate;

    // Sample input color and mask
    half4 inputColor = inputTexture.sample(texturesampler, textureCoordinate);
    half maskValue = maskTexture.sample(texturesampler, textureCoordinate).r;

    half4 outputColor;

    if (mode < 0.5) {
        // Mode 0: Extract - keep mask areas, make non-mask transparent
        outputColor = inputColor * maskValue;

    } else if (mode < 1.5) {
        // Mode 1: Extract Background - keep non-mask areas, make mask transparent
        half invertedMask = 1.0 - maskValue;
        outputColor = inputColor * invertedMask;

    } else if (mode < 2.5) {
        // Mode 2: Output Mask - show mask as grayscale
        outputColor = half4(maskValue, maskValue, maskValue, 1.0);

    } else {
        outputColor = inputColor * maskValue;
    }

    return outputColor;
}
