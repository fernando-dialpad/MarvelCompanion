// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarvelRoot",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MarvelRoot",
            targets: ["MarvelRoot"]),
    ],
    dependencies: [
        .package(path: "../MarvelCharacter"),
        .package(path: "../MarvelEvent"),
        .package(path: "../MarvelFavorite"),
        .package(path: "../MarvelAlert"),
        .package(path: "../../Infrastructure/Notifier"),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MarvelRoot",
            dependencies: [
                .product(name: "MarvelCharacter", package: "MarvelCharacter"),
                .product(name: "MarvelEvent", package: "MarvelEvent"),
                .product(name: "MarvelFavorite", package: "MarvelFavorite"),
                .product(name: "MarvelAlert", package: "MarvelAlert"),
                .product(name: "Notifier", package: "Notifier")
            ]),
        .testTarget(
            name: "MarvelRootTests",
            dependencies: ["MarvelRoot"]),
    ]
)
