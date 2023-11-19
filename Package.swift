// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-mail-driver-smtp",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "FeatherMailDriverSMTP", targets: ["FeatherMailDriverSMTP"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.62.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.25.0"),
        .package(url: "https://github.com/feather-framework/feather-mail.git", .upToNextMinor(from: "0.1.0")),
    ],
    targets: [
        .target(name: "NIOSMTP", dependencies: [
            .product(name: "NIO", package: "swift-nio"),
            .product(name: "NIOSSL", package: "swift-nio-ssl"),
            .product(name: "Logging", package: "swift-log"),
        ]),
        .target(
            name: "FeatherMailDriverSMTP",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .target(name: "NIOSMTP"),
            ]
        ),
        .testTarget(name: "NIOSMTPTests", dependencies: [
            .target(name: "NIOSMTP"),
        ]),
        .testTarget(
            name: "FeatherMailDriverSMTPTests",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "XCTFeatherMail", package: "feather-mail"),
                .target(name: "FeatherMailDriverSMTP"),
            ]
        ),
    ]
)
