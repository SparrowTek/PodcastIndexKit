// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PodcastIndexKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17),
        .watchOS(.v10),
        .tvOS(.v17),
    ],
    products: [
        .library(
            name: "PodcastIndexKit",
            targets: ["PodcastIndexKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PodcastIndexKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]),
    ]
)
