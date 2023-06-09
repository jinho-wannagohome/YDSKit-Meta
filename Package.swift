// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YDSKit-Meta",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "YDSKit-Meta",
            type: .dynamic,
            targets: ["YDSKit-Meta"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/slackhq/PanModal.git", from: .init(1, 2, 6)),
        .package(url: "https://github.com/taeminyun/Toaster", exact: "2.3.1"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.6.0")
    ],
    targets: [
        .target(
            name: "YDSKit-Meta",
            dependencies: [
                "PanModal",
                "Toaster",
                "SnapKit"
            ],
            path: ".",
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
