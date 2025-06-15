// swift-tools-version: 6.0

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
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.26.0"),
    ],
    targets: [
        .target(
            name: "PodcastIndexKit",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]),
    ]
)
