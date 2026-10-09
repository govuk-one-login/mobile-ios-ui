// swift-tools-version: 6.0

import PackageDescription

// Detect if this package is being built as a remote dependency checkout
let isDependencyCheckout = #filePath.contains("/checkouts/")

var dependencies: [Package.Dependency] = []
var plugins: [Target.PluginUsage] = []

// Only add SwiftLint when developing locally, NOT when consumed as a dependency
if !isDependencyCheckout {
    dependencies.append(
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.58.2")
    )
    dependencies.append(
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.18.7"
        )
    )
    plugins.append(
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
    )
}

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
    dependencies: dependencies,
    targets: [
        .target(
            name: "DesignSystem",
            path: "Sources",
            resources: [
                .process("Utilities/Resources")
            ],
            plugins: plugins
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
