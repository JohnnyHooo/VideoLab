# VideoLab Swift Package Manager 支持

VideoLab 现在支持 Swift Package Manager (SPM)！

## 安装

### 在 Xcode 中使用

1. 在 Xcode 中打开你的项目
2. 选择 `File` → `Add Package Dependencies...`
3. 输入仓库 URL: `https://github.com/JohnnyHooo/VideoLab.git`
4. 选择版本并点击 `Add Package`

### 在 Package.swift 中使用

```swift
// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "YourProject",
    platforms: [
        .iOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/JohnnyHooo/VideoLab.git", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "YourProject",
            dependencies: ["VideoLab"]
        )
    ]
)
```

## 使用示例

```swift
import VideoLab

// 创建渲染组合
let composition = RenderComposition()
composition.renderSize = CGSize(width: 1280, height: 720)

// 创建视频源
let url = Bundle.main.url(forResource: "video", withExtension: "mov")!
let asset = AVAsset(url: url)
let videoSource = AVAssetSource(asset: asset)

// 创建渲染层
let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
let renderLayer = RenderLayer(timeRange: timeRange, source: videoSource)

// 添加到组合中
composition.layers = [renderLayer]

// 创建 VideoLab 实例
let videoLab = VideoLab(renderComposition: composition)
```

## 系统要求

- iOS 14.0+
- Swift 5.0+
- Xcode 12.0+

## 注意事项

由于 VideoLab 使用了 UIKit 和 AVFoundation，目前仅支持 iOS 平台。macOS 支持可能在未来版本中添加。
