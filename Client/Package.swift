// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Client",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Client",
            targets: ["Client"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/IBM-Swift/BlueSocket", from: "1.0.0"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Client"),
        .testTarget(
            name: "ClientTests",
            dependencies: ["Clint"]),
    ]
)
