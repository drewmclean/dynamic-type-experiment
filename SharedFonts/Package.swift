// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SharedFonts",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SharedFonts",
            targets: ["SharedFonts"]),
    ],
    dependencies: [
        .package(url: "https://github.com/rabbit-rabbit-rabbit/PlayHelpers", branch: "font-extensions"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SharedFonts",
            dependencies: [
                .product(name: "PlayHelpers", package: "PlayHelpers"),
            ],
            resources: [
                .process("Resources")  // This includes the Fonts folder in the package
            ]
        ),
    ]
)
