// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutolayoutExtension",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AutolayoutExtension",
            targets: ["AutolayoutExtension"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "AutolayoutExtension",
            dependencies: [],
            plugins: []
        ),
        .testTarget(
            name: "AutolayoutExtensionTests",
            dependencies: ["AutolayoutExtension"]),
    ]
)
