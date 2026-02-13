// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FFmpegKitAppleLite",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "FFmpegKit",
            targets: ["FFmpegKit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "FFmpegKit",
            url: "RELEASE_URL",
            checksum: "CHECKSUM_VALUE"
        )
    ]
)