// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DonetSite",
    products: [
        .library(name: "Donet", targets:["Donet"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio", from: "2.33.0"),
    ],
    targets: [
        .target(name: "Donet", dependencies: [
            .product(name: "NIO", package: "swift-nio"),
            .product(name: "NIOHTTP1", package: "swift-nio")
        ]),
        .executableTarget(
            name: "DonetSite",
            dependencies: ["Donet"]),
        .testTarget(
            name: "DonetSiteTests",
            dependencies: ["DonetSite"]),
    ]
)
