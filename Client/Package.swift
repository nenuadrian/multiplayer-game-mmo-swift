
import PackageDescription

let package = Package(
    name: "Client",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/BlueSocket", majorVersion: 0, minor: 12),
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0),
        .Package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", majorVersion: 1)
    ]
)
