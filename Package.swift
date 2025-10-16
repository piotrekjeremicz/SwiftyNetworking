// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftyNetworking",
    platforms: [
        .iOS(.v17),
        .tvOS(.v17),
        .macOS(.v15),
        .watchOS(.v11),
        .visionOS(.v2),
        .macCatalyst(.v15),
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "602.0.0"),
    ],
    targets: [
        .macro(
            name: "NetworkingMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .target(
            name: "Networking",
            dependencies: ["NetworkingMacros"],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .executableTarget(
            name: "NetworkingExample",
            dependencies: ["Networking"],
            path: "Examples/NetworkingExample",
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .defaultIsolation(MainActor.self)
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

