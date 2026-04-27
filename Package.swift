// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HomerUIKit",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "HomerUIKit", targets: ["HomerUIKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/akkanferhan/HomerFoundation.git", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "HomerUIKit",
            dependencies: [
                .product(name: "HomerFoundation", package: "HomerFoundation")
            ],
            path: "Sources/HomerUIKit"
        ),
        .testTarget(
            name: "HomerUIKitTests",
            dependencies: ["HomerUIKit"],
            path: "Tests/HomerUIKitTests"
        )
    ],
    swiftLanguageModes: [.v6]
)
