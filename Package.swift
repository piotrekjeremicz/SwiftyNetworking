// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyNetworking",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.9.0"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.2"),
        
    ],
    targets: [
        .target(name: "Networking", dependencies: ["XMLCoder", "AnyCodable"])
    ]
)
