// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutorestSwift",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/jpsim/Yams.git", from: "3.0.1"),
        .package(url: "https://github.com/stencilproject/Stencil.git", .branch("trim_whitespace")),
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
        .package(name: "AzureSDK", url: "https://github.com/Azure/azure-sdk-for-ios.git", .branch("master")),
        .package(name: "AutoRestHeadTest", path: "./test/integration/generated/head/")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AutorestSwift",
            dependencies: [
                "Yams",
                "Stencil",
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio")
            ]
        ),
        .testTarget(
            name: "AutorestSwiftTest",
            dependencies: [.product(name: "AzureCore", package: "AzureSDK"), "AutoRestHeadTest"],
            path: "AutorestSwiftTest"
        )
    ],
    swiftLanguageVersions: [.v5]
)
