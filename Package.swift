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
        .library(
            name: "NetworkingMacro",
            targets: ["NetworkingMacro"]
        ),
        .executable(
            name: "NetworkingMacroClient",
            targets: ["NetworkingMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .target(name: "Networking", dependencies: []),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "NetworkingMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "NetworkingMacro", dependencies: ["NetworkingMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "NetworkingMacroClient", dependencies: ["NetworkingMacro"]),
        
        // A test target used to develop the macro implementation.
        .testTarget(
            name: "MyMacroTests",
            dependencies: [
                "NetworkingMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        
        //TODO: Temporary target removal
//        .testTarget(
//            name: "NetworkingTests",
//            dependencies: ["Networking", "Quick", "Nimble"]),
    ]
)
