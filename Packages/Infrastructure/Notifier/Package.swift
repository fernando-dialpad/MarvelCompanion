// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Notifier",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Notifier",
            targets: ["Notifier"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ably/ably-cocoa", from: "1.2.19"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "0.0.3"),
        .package(path: "../../Support/Core"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Notifier",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Ably", package: "ably-cocoa"),
                .product(name: "Core", package: "Core")
            ],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "NotifierTests",
            dependencies: ["Notifier"]),
    ]
)
