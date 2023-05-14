// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bluelytics",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Bluelytics",
            targets: ["Bluelytics"]
        ),
    ],
    targets: [
        .target(
            name: "Bluelytics"),
        .testTarget(
            name: "BluelyticsTests",
            dependencies: ["Bluelytics"]
        ),
    ]
)
