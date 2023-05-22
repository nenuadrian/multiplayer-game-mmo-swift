// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Server",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Server",
            targets: ["Server"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/IBM-Swift/BlueSocket", from: "0.0.1"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "0.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Server"),
        .testTarget(
            name: "ServerTests",
            dependencies: ["Server"]),
    ]
)
