// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SudoDIRelay",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SudoDIRelay",
            targets: ["SudoDIRelay"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sudoplatform/sudo-user-ios.git", from: "18.0.0"),
        .package(url: "https://github.com/sudoplatform/sudo-logging-ios.git", from: "2.0.0"),
        .package(url: "https://github.com/sudoplatform/sudo-key-manager-ios.git", from: "4.0.0"),
        .package(url: "https://github.com/sudoplatform/sudo-api-client-ios.git", from: "13.0.0"),
        .package(url: "https://github.com/aws-amplify/amplify-swift", from: "2.45.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SudoDIRelay",
            dependencies: [                
                .product(name: "Amplify", package: "amplify-swift"),
                .product(name: "SudoLogging", package: "sudo-logging-ios"),
                .product(name: "SudoKeyManager", package: "sudo-key-manager-ios"),
                .product(name: "SudoUser", package: "sudo-user-ios"),
                .product(name: "SudoApiClient", package: "sudo-api-client-ios")
            ],
            path: "SudoDIRelay/"),
    ]
)
