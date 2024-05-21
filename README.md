# Feather Mail Driver SMTP

A mail driver for the Feather CMS mail component using NIO SMTP.

## Getting started

⚠️ This repository is a work in progress, things can break until it reaches v1.0.0. 

Use at your own risk.

### Adding the dependency

To add a dependency on the package, declare it in your `Package.swift`:

```swift
.package(url: "https://github.com/feather-framework/feather-mail-driver-smtp", .upToNextMinor(from: "0.4.0")),
```

and to your application target, add `FeatherMailDriverSMTP` to your dependencies:

```swift
.product(name: "FeatherMailDriverSMTP", package: "feather-mail-driver-smtp")
```

Example `Package.swift` file with `FeatherMailDriverSMTP` as a dependency:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "my-application",
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-mail-driver-smtp", .upToNextMinor(from: "0.4.0")),
    ],
    targets: [
        .target(name: "MyApplication", dependencies: [
            .product(name: "FeatherMailDriverSMTP", package: "feather-mail-driver-smtp")
        ]),
        .testTarget(name: "MyApplicationTests", dependencies: [
            .target(name: "MyApplication"),
        ]),
    ]
)
```

## Credits 

The NIOSMTP library is heavily inspired by [Mikroservices/Smtp](https://github.com/Mikroservices/Smtp).


name: Update DocC Documentation
script: | 
  swift package --allow-writing-to-directory ./docs \
    generate-documentation --target MusadoraKit \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path MusadoraKit \
    --output-path ./docs

  git add .
  git commit -m "[skip ci] Update DocC Documentation"
  git remote set-url origin https://rudrankriyam:$token@github.com/rryam/MusadoraKit.git
  git pull
  git push origin main
