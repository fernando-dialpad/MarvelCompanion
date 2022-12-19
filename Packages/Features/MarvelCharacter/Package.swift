// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarvelCharacter",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MarvelCharacter",
            targets: ["MarvelCharacter"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main"),
        .package(path: "../../Infrastructure/DataManager"),
        .package(path: "../../Support/CoreUI")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MarvelCharacter",
            dependencies: [
//                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "DataManager", package: "DataManager"),
                .product(name: "CoreUI", package: "CoreUI")
            ]),
        .testTarget(
            name: "MarvelCharacterTests",
            dependencies: ["MarvelCharacter"]),
    ]
)
