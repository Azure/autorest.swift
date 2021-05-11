// swift-tools-version:5.0
//  The swift-tools-version declares the minimum version of Swift required to build this package.
//
// --------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// --------------------------------------------------------------------------

import PackageDescription

let package = Package(
    name: "AutoRestSwaggerBatArray",
    platforms: [
        .macOS(.v10_14), .iOS(.v12), .tvOS(.v12)
    ],
    products: [
        .library(name: "AutoRestSwaggerBatArray", type: .static, targets: ["AutoRestSwaggerBatArray"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/Azure/SwiftPM-AzureCore.git",
            .branch("dev/AzureCore")
        )
    ],
    targets: [
        // Build targets
        .target(
            name: "AutoRestSwaggerBatArray",
            dependencies: ["AzureCore"],
            path: "Source"
        )
    ],
    swiftLanguageVersions: [.v5]
)
