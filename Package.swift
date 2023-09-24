// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftyNetworking",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    
    targets: [
        .target(name: "Networking", dependencies: ["NetworkingMacros"]),
        .macro(
            name: "NetworkingMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        
        .testTarget(
            name: "NetworkingMacroTests",
            dependencies: [
                "NetworkingMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        
        //TODO: Temporary test targets removal
//        .testTarget(
//            name: "NetworkingTests",
//            dependencies: ["Networking", "Quick", "Nimble"]),
    ]
)
