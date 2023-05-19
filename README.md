# PodcastIndexKit

PodcastIndexKit is a Swift Package to easily integrate with the Podcasting 2.0 API at [podcastindex.org](https://podcastindex.org)

## Usage

### Adding the Swift-DocC Plugin as a Dependency

To use PodcastIndexKit with your package, first add it as a dependency:

```swift
let package = Package(
	// name, platforms, products, etc.
	dependencies: [
		// other dependencies
		.package(url: "https://github.com/SparrowTek/PodcastIndexKit", from: "1.0.0"),
	],
	targets: [
		// targets
	]
)
```

Swift 5.8 is required in order to run the plugin.

## Documentation

Click here to see all [documentation](podcastindexkit.sparrowtek.com/documentation/PodcastIndexKit).

## Note

This package requires a [PodcastIndex API key](https://api.podcastindex.org).  
This package currently only supports API read endpoints. API write endpoints are not supported.