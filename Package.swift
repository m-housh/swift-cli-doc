// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "swift-cli-doc",
  products: [
    .library(name: "CliDoc", targets: ["CliDoc"])
  ],
  dependencies: [
    .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0")
  ],
  targets: [
    .target(
      name: "CliDoc",
      dependencies: [
        .product(name: "Rainbow", package: "Rainbow")
      ]

    ),
    .testTarget(
      name: "CliDocTests",
      dependencies: ["CliDoc"]
    )
  ]
)
