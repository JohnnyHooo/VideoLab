//
//  RenderLayer.swift
//  VideoLab
//
//  Created by Bear on 2020/8/29.
//  Copyright © 2020 Chocolate. All rights reserved.
//

import AVFoundation

public class RenderLayer: Animatable {
    public let layerId: String = UUID().uuidString

    public var timeRange: CMTimeRange {
        didSet {
            self.updateTimeRangeInRoot()
        }
    }

    public var layerLevel: Int = 0
    public var transform: Transform = Transform.identity
    public var blendMode: BlendMode = BlendModeNormal
    public var blendOpacity: Float = 1.0
    public var operations: [BasicOperation] = []

    public var audioConfiguration: AudioConfiguration = AudioConfiguration()

    private(set) var source: Source?
    public var layerSource: Source? { source }

    private(set) weak var superLayer: RenderLayer?
    public var timeRangeInRoot: CMTimeRange = .invalid

    public init(timeRange: CMTimeRange, source: Source? = nil) {
        self.timeRange = timeRange
        self.source = source
        self.source?.weakContainerLayer = self

        self.updateTimeRangeInRoot()
    }

    // MARK: - Animatable
    public var animations: [KeyframeAnimation]?
    public func updateAnimationValues(at time: CMTime) {
        if let blendOpacity = KeyframeAnimation.value(for: "blendOpacity", at: time, animations: animations) {
            self.blendOpacity = blendOpacity
        }
        transform.updateAnimationValues(at: time)

        for operation in operations {
            let operationStartTime = operation.timeRange?.start ?? CMTime.zero
            let operationInternalTime = time - operationStartTime
            operation.updateAnimationValues(at: operationInternalTime)
        }
    }

    // MARK: -
    public func updateSuperLayer(_ superLayer: RenderLayer?) {
        self.superLayer = superLayer
        self.updateTimeRangeInRoot()
    }


    public func updateTimeRangeInRoot() {
        let timeRangeInRoot = self.matchTimeRangeInRoot(self.timeRange, superLayer: superLayer)
        self.timeRangeInRoot = timeRangeInRoot
    }

    public func matchTimeRangeInRoot(_ timeRange: CMTimeRange, superLayer: RenderLayer?) -> CMTimeRange {
        guard let superLayer else {
            return timeRange
        }

        let superLayerTimeRange = self.matchTimeRangeInRoot(superLayer.timeRange, superLayer: superLayer.superLayer)
        var rangInSuperLayer = timeRange
        rangInSuperLayer.start = superLayerTimeRange.start + timeRange.start
        return rangInSuperLayer
    }


    // MARK: -
    public func syncTimes(compositionTime: CMTime, instructionTimeRange: CMTimeRange) {
        self.layerSource?.syncTimes(compositionTime: compositionTime, instructionTimeRange: instructionTimeRange)
    }
}
