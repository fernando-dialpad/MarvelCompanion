// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataManager",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DataManager",
            targets: ["DataManager"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../../Support/SharedModels"),
        .package(path: "../../Support/Core"),
        .package(path: "../Network"),
        .package(path: "../Notifier"),
        .package(path: "../Storage")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DataManager",
            dependencies: [
                .product(name: "SharedModels", package: "SharedModels"),
                .product(name: "Core", package: "Core"),
                .product(name: "Network", package: "Network"),
                .product(name: "Notifier", package: "Notifier"),
                .product(name: "Storage", package: "Storage")
            ]),
        .testTarget(
            name: "DataManagerTests",
            dependencies: ["DataManager"]),
    ]
)
