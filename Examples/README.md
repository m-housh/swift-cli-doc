# swift-cli-doc

A tool for building rich documentation for command line applications using result builders and
syntax similar to `SwiftUI`.

## Getting Started

Add this as a package dependency to your command line application.

```swift
let package = Package(
  name: "my-tool"
  ...
  dependencies: [
    .package(url: "https://git.housh.dev/michael/swift-cli-doc", from: "0.1.0")
  ],
  targets: [
    .executableTarget(
      name: "my-tool",
      dependencies: [
        .product(name: "CliDoc", package: "swift-cli-doc")
      ]
    )
  ]
)
```
