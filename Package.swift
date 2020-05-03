// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CoTweeps",
    products: [
        .library(name: "CoTweeps", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "Leaf", "Logging"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

