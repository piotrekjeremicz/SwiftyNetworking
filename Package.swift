// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyNetworking",
    platforms: [
        .iOS(.v26),
        .tvOS(.v26),
        .macOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
        .macCatalyst(.v26),
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
        ),
    ],
    targets: [
        .target(
            name: "Networking",
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .defaultIsolation(MainActor.self)
            ]
        ),
        .executableTarget(
            name: "NetworkingExample",
            dependencies: ["Networking"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
    ]
)

