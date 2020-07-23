// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutorestSwift",
    platforms: [
        .macOS(.v10_14)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "3.0.1"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AutorestSwift",
            dependencies: ["Yams", "Stencil"]
        ),
        .testTarget(
            name: "AutorestSwiftTests",
            dependencies: ["AutorestSwift", "Yams", "Stencil"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
