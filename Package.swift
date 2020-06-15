// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sendgrid-swift",
    products: [
        .library(
            name: "SendGrid",
            targets: ["SendGrid"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SendGrid",
            dependencies: []),
        .testTarget(
            name: "SendGridTests",
            dependencies: ["SendGrid"]),
    ]
)
