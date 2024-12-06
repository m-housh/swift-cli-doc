// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "CliDoc-Examples",
  products: [
    .executable(name: "examples", targets: ["CliDoc-Examples"])
  ],
  dependencies: [
    .package(path: "../"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0")
  ],
  targets: [
    .executableTarget(
      name: "CliDoc-Examples",
      dependencies: [
        .product(name: "CliDoc", package: "swift-cli-doc"),
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]
    ),
    .testTarget(
      name: "CliDoc-ExamplesTests",
      dependencies: ["CliDoc-Examples"]
    )
  ]
)
