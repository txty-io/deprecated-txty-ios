// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "texterify-ios-sdk",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "texterify-ios-sdk", targets: ["texterify-ios-sdk"])
    ],
    targets: [
        .target(name: "texterify-ios-sdk", dependencies: [], path: "texterify-ios-sdk/")
    ],
    swiftLanguageVersions: [.v5]
)
