// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SPMTest",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .executable(name: "SPMTest", targets: ["SPMTest"])
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "SPMTest",
            dependencies: ["VideoLab"]
        )
    ]
)
