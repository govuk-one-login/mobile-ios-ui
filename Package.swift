// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DesignSystem",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
        .library(
            name: "SnapshotHelpers",
            targets: ["SnapshotHelpers"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/SimplyDanny/SwiftLintPlugins",
            .upToNextMajor(from: "0.58.2")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.18.7"
        )
    ],
    targets: [
        .target(
            name: "DesignSystem",
            path: "Sources",
            resources: [
                .process("Utilities/Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "SnapshotHelpers",
            dependencies: [
                "DesignSystem",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "SnapshotHelpers/Sources",
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: [
                "DesignSystem",
                "SnapshotHelpers"
            ],
            path: "Tests"
        )
    ]
)
