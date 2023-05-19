// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "PodcastIndexKit",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "PodcastIndexKit",
            targets: ["PodcastIndexKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Get", .upToNextMajor(from: "2.1.6")),
        .package(url: "https://github.com/apple/swift-crypto", .upToNextMajor(from: "2.5.0")),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "PodcastIndexKit",
            dependencies: [
                "Get",
                .product(name: "Crypto", package: "swift-crypto"),
            ]),
    ]
)
