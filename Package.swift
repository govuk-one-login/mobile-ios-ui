// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"])
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", .upToNextMajor(from: "0.58.2"))
    ],
    targets: [
        .target(
            name: "DesignSystem",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"]
        )
    ]
)
