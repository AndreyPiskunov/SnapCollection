// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SnapCollection",
    platforms: [.iOS("11.0")],
    products: [.library(name: "SnapCollection", targets: ["SnapCollection"])],
    dependencies: [],
    targets: [.target(
        name: "SnapCollection",
        dependencies: [],
        path: "Sources/SnapCollection"
    )],
    swiftLanguageVersions: [.v4_2]
)
