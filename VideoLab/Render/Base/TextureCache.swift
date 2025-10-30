//
//  TextureCache.swift
//  VideoLab
//
//  Created by Bear on 2020/8/12.
//  Copyright © 2020 Chocolate. All rights reserved.
//

import Metal

public class TextureCache {
    private var textureCache = [String:[Texture]]()

    private let queue = DispatchQueue(label: "com.videolab.texturecache", attributes: .concurrent)

    public func requestTexture(pixelFormat: MTLPixelFormat = .bgra8Unorm, width: Int, height: Int) -> Texture? {
        let hash = hashForTexture(pixelFormat: pixelFormat, width: width, height: height)

        return queue.sync(flags: .barrier) {
            if let textures = textureCache[hash], !textures.isEmpty {
                var mutableTextures = textures
                let texture = mutableTextures.removeLast()
                textureCache[hash] = mutableTextures
                return texture
            } else {
                return Texture.makeTexture(pixelFormat: pixelFormat, width: width, height: height)
            }
        }
    }

    public func returnToCache(_ texture: Texture) {
        Texture.clearTexture(texture)
        let hash = hashForTexture(pixelFormat: texture.texture.pixelFormat, width: texture.width, height: texture.height)

        queue.async(flags: .barrier) {
            if self.textureCache[hash] != nil {
                self.textureCache[hash]?.append(texture)
            } else {
                self.textureCache[hash] = [texture]
            }
        }
    }

    public func purgeAllTextures() {
        queue.async(flags: .barrier) {
            self.textureCache.removeAll()
        }
    }

    private func hashForTexture(pixelFormat: MTLPixelFormat = .bgra8Unorm, width: Int, height: Int) -> String {
        return "\(width)x\(height)-\(pixelFormat)"
    }
}
