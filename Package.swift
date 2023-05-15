// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTokenGen",
    platforms: [
      .macOS(.v13)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.2.2"),
        .package(url: "https://github.com/jpsim/Yams.git", exact: "5.0.5"),
        .package(url: "https://github.com/kylef/Stencil.git", exact: "0.15.1"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "SwiftTokenGen",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Yams",
                "Stencil",
                "AnyCodable"
            ],
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(name: "SwiftTokenGenTest",
                    dependencies: ["SwiftTokenGen"],
                    path: "Tests")
    ]
)
