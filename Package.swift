// swift-tools-version: 5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VideoLab",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "VideoLab",
            targets: ["VideoLab"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        .target(
            name: "VideoLab",
            dependencies: [],
            path: "VideoLab",
            resources: [
                .copy("VideoLab.bundle"),
                .process("**/*.metal")
            ]
        ),
        .testTarget(
            name: "VideoLabTests",
            dependencies: ["VideoLab"],
            path: "Tests/VideoLabTests"
        ),
    ]
)
