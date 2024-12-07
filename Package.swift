// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "swift-cli-doc",
  products: [
    .library(name: "CliDocCore", targets: ["CliDocCore"]),
    .library(name: "CliDoc", targets: ["CliDoc"])
  ],
  dependencies: [
    .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0")
  ],
  targets: [
    .target(
      name: "CliDocCore",
      dependencies: [
        .product(name: "Rainbow", package: "Rainbow")
      ]
    ),
    .testTarget(
      name: "CliDocCoreTests",
      dependencies: ["CliDocCore"]
    ),
    .target(
      name: "CliDoc",
      dependencies: [
        "CliDocCore",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Rainbow", package: "Rainbow")
      ]
    ),
    .testTarget(
      name: "CliDocTests",
      dependencies: ["CliDocCore", "CliDoc"]
    )
  ]
)
