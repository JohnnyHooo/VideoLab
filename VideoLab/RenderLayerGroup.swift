//
//  RenderLayerGroup.swift
//  VideoLab
//
//  Created by Bear on 2020/8/19.
//  Copyright © 2020 Chocolate. All rights reserved.
//

import AVFoundation

public class RenderLayerGroup: RenderLayer {
    public override var timeRange: CMTimeRange {
        set {
            super.timeRange = newValue
        }
        get {
            return super.timeRange
        }
    }
    public var layers: [RenderLayer] = []

    public func addLayers(_ layers: [RenderLayer]) {
        layers.forEach { layer in
            self.addLayer(layer)
        }
    }
    public func addLayer(_ layer: RenderLayer) {
        layers.append(layer)
        layer.updateSuperLayer(self)
    }

    public func clearLayers() {
        layers.forEach({
            if $0.superLayer === self {
                $0.updateSuperLayer(nil)
            }
        })
        layers.removeAll()
    }

    public func updateLayers() {
        self.layers.forEach({ $0.updateTimeRangeInRoot() })
    }
}
