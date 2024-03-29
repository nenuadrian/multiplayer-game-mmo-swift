// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "mmo",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .executable(
      name: "Server",
      targets: ["Server"]),
    .library(
      name: "Common",
      targets: ["Common"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.0.0"),
    .package(url: "https://github.com/IBM-Swift/BlueSocket", from: "2.0.0"),
    .package(
      url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "2.0.0")),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Common",
      dependencies: [
        .product(name: "Socket", package: "BlueSocket"),
        .product(name: "SwiftyBeaver", package: "SwiftyBeaver"),
      ]),
    .testTarget(
      name: "CommonTests",
      dependencies: ["Common"]),
    .executableTarget(
      name: "Server",
      dependencies: [
        "Common", .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]),
    .testTarget(
      name: "ServerTests",
      dependencies: ["Server"]),
  ]
)
