# PodcastIndexKit

PodcastIndexKit is a Swift Package to easily integrate with the Podcasting 2.0 API at [podcastindex.org](https://podcastindex.org)  

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSparrowTek%2FPodcastIndexKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/SparrowTek/PodcastIndexKit) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSparrowTek%2FPodcastIndexKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/SparrowTek/PodcastIndexKit)

## Usage

### Adding the Swift-DocC Plugin as a Dependency

To use PodcastIndexKit with your package, first add it as a dependency:

```swift
let package = Package(
	// name, platforms, products, etc.
	dependencies: [
		// other dependencies
		.package(url: "https://github.com/SparrowTek/PodcastIndexKit", from: "0.1.1"),
	],
	targets: [
		// targets
	]
)
```

Swift 5.8 is required in order to run the plugin.

### Setup

Before making any API requests you must setup the `PodcastIndexKit` package using the `setup` method.  

```swift
PodcastIndexKit.setup(apiKey: "YOUR_API_KEY", apiSecret: "YOUR_API_SECRET", userAgent: "YOUR_APP_USER_AGENT")
```

## Documentation

Click here to see all [documentation](https://sparrowtek.com/PodcastIndexKit/documentation/podcastindexkit/).

## Note

This package requires a [PodcastIndex API key](https://api.podcastindex.org).  
This package currently only supports API read endpoints. API write endpoints are not supported.  
Not all endpoints have been tested yet. If you find any bugs please open a PR.  
