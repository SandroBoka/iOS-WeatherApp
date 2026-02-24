// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Weather",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Weather",
            targets: ["Weather"])
    ],
    dependencies: [
        // Add RealmSwift as a dependency
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.39.0") // Use the latest version
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Weather",
            dependencies: [
                // Add RealmSwift as a dependency to your target
                .product(name: "RealmSwift", package: "realm-swift")
            ])
    ]
)
