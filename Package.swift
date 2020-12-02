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
        .package(url: "https://github.com/tjprescott/Yams.git", .branch("CircularReferences")),
        .package(url: "https://github.com/stencilproject/Stencil.git", .branch("trim_whitespace")),
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
        .package(name: "AzureSDK", path: "../azure-sdk-for-ios"),
//        .package(
//            name: "AzureSDK",
//            url: "https://github.com/Azure/azure-sdk-for-ios.git",
//            .branch("dev/AzureCore")
//        ),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.45.6"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.40.1"),
//        .package(name: "AutoRestHeadTest", path: "./test/integration/generated/head/"),
//        .package(name: "AutoRestSwaggerBatFile", path: "./test/integration/generated/body-file/"),
//        .package(name: "XmsErrorResponseExtensions", path: "./test/integration/generated/xms-error-responses/"),
        .package(name: "AutoRestReport", path: "./test/integration/generated/report/"),
        .package(name: "AutoRestIntegerTest", path: "./test/integration/generated/body-integer/"),
        .package(name: "AutoRestUrlTest", path: "./test/integration/generated/url/"),
//        .package(name: "AutoRestResourceFlatteningTest", path: "./test/integration/generated/model-flattening/"),
//        .package(name: "AutoRestParameterizedHostTest", path: "./test/integration/generated/custom-baseUrl/"),
//        .package(name: "AutoRestSwaggerBat", path: "./test/integration/generated/body-string/"),
//        .package(name: "AutoRestSwaggerBatByte", path: "./test/integration/generated/body-byte/"),
//        .package(name: "AutoRestNumberTest", path: "./test/integration/generated/body-number/"),
//        .package(name: "AutoRestSwaggerBatHeader", path: "./test/integration/generated/header/"),
//        .package(name: "AutoRestSwaggerBatArray", path: "./test/integration/generated/body-array/"),
        .package(name: "AutoRestDateTest", path: "./test/integration/generated/body-date/"),
        .package(name: "AutoRestRfC1123DateTimeTest", path: "./test/integration/generated/body-datetime-rfc1123/"),
//        .package(name: "AutoRestDateTimeTest", path: "./test/integration/generated/body-datetime/"),
//        .package(name: "AutoRestBoolTest", path: "./test/integration/generated/body-boolean/"),
//        .package(name: "AutoRestUrlMutliCollectionFormatTest", path: "./test/integration/generated/url-multi-collectionFormat/"),
//        .package(name: "AutoRestParameterizedCustomHostTest", path: "./test/integration/generated/custom-baseUrl-more-options")
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
            dependencies: [
                .product(name: "AzureCore", package: "AzureSDK"),
//            "AutoRestHeadTest",
//            "AutoRestSwaggerBatFile",
//            "XmsErrorResponseExtensions",
            "AutoRestReport",
            "AutoRestIntegerTest",
            "AutoRestUrlTest",
//            "AutoRestResourceFlatteningTest",
//            "AutoRestParameterizedHostTest",
//            "AutoRestSwaggerBat",
//            "AutoRestSwaggerBatByte",
//            "AutoRestNumberTest",
//            "AutoRestSwaggerBatHeader",
//            "AutoRestSwaggerBatArray",
            "AutoRestDateTest",
            "AutoRestRfC1123DateTimeTest",
//            "AutoRestDateTimeTest",
//            "AutoRestBoolTest",
//            "AutoRestUrlMutliCollectionFormatTest",
//            "AutoRestParameterizedCustomHostTest"
            ],
            path: "AutorestSwiftTest"
        )
    ],
    swiftLanguageVersions: [.v5]
)
