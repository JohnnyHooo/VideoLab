//
//  Passthrough.swift
//  VideoLab
//
//  Created by Bear on 2020/8/12.
//  Copyright © 2020 Chocolate. All rights reserved.
//

import Foundation
import simd

public class Passthrough: BasicOperation {
    public init () {
        super.init(fragmentFunctionName: "oneInputPassthroughFragment", numberOfInputs: 1)
        enableOutputTextureRead = false
    }
}

public class RotatePassthrough: BasicOperation {
    public init () {
        super.init(vertexFunctionName: "rotatePassthroughVertex", fragmentFunctionName: "rotatePassthroughFragment", numberOfInputs: 1)
        enableOutputTextureRead = false
    }

    public var orientation: float4x4 = float4x4.identity() {
        didSet {
            uniformSettings["orientation"] = orientation
        }
    }
}

