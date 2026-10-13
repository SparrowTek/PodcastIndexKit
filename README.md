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
		.package(url: "https://github.com/SparrowTek/PodcastIndexKit", from: "0.5.0"),
	],
	targets: [
		// targets
	]
)
```

Swift 5.9 is required in order to run the plugin.

### Setup

Before making any API requests you must setup the `PodcastIndexKit` package using the `setup` method.  

```swift
PodcastIndexKit.setup(apiKey: "YOUR_API_KEY", apiSecret: "YOUR_API_SECRET", userAgent: "YOUR_APP_USER_AGENT")
```

> **Keep the key out of client apps.** Podcast Index's terms of service (v2.0) forbid shipping the API key or secret in client-side code, including iOS, Android and web apps, where anyone can extract them from the binary. Call `setup` only on a server you control and have your app talk to that server. Every request must also carry a User-Agent that names your application.

### Raw responses and custom transports

Servers that cache Podcast Index responses can read the exact bytes the API returned with `PodcastIndexRawService`, then decode them later with `JSONDecoder.podcastIndexDecoder`. Pass a `PodcastIndexNetworking` implementation to `setup` to stub the network in tests or to route requests through another HTTP client.

The package builds on Linux, where `swift-crypto` stands in for CryptoKit.

## Documentation

Click here to see all [documentation](https://swiftpackageindex.com/SparrowTek/PodcastIndexKit/documentation/podcastindexkit).

## Note

This package requires a [PodcastIndex API key](https://api.podcastindex.org).  
This package currently only supports API read endpoints. API write endpoints are not supported.  
Not all endpoints have been tested yet. If you find any bugs please open a PR.  
