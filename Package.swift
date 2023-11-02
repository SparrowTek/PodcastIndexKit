// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PodcastIndexKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(
            name: "PodcastIndexKit",
            targets: ["PodcastIndexKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "PodcastIndexKit",
            dependencies: []),
    ]
)
