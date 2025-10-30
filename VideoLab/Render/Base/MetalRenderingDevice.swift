//
//  MetalRenderingDevice.swift
//  VideoLab
//
//  Created by Bear on 2020/8/7.
//  Copyright (c) 2020 Chocolate. All rights reserved.
//

import Foundation
import Metal

public let sharedMetalRenderingDevice = MetalRenderingDevice()

public class MetalRenderingDevice {
    public let device: MTLDevice
    public let commandQueue: MTLCommandQueue
    public let shaderLibrary: MTLLibrary
    public let textureCache = TextureCache()

    public init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create Metal Device")
        }
        self.device = device
        
        guard let queue = self.device.makeCommandQueue() else {
            fatalError("Could not create command queue")
        }
        self.commandQueue = queue

        do {
            // Try to create library from default sources first (SPM compatible)
            if let defaultLibrary = device.makeDefaultLibrary() {
                self.shaderLibrary = defaultLibrary
            } else {
                // Fallback to bundle-based loading (CocoaPods compatible)
                let frameworkBundle = Bundle(for: MetalRenderingDevice.self)
                guard let metalLibraryPath = frameworkBundle.path(forResource: "default", ofType: "metallib") else {
                    fatalError("Could not find Metal library in bundle")
                }
                self.shaderLibrary = try device.makeLibrary(filepath: metalLibraryPath)
            }
        } catch {
            fatalError("Could not load Metal library: \(error)")
        }
    }
}
