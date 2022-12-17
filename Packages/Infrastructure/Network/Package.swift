// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main"),
        .package(path: "../../Support/SharedModels"),
        .package(path: "../../Support/Core"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.0")
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Network",
            dependencies: [
//                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "AnyCodable", package: "AnyCodable"),
                .product(name: "SharedModels", package: "SharedModels"),
                .product(name: "Core", package: "Core")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]
        ),
    ]
)
