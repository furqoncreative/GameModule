// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameModule",
    platforms: [.iOS(.v14), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GameModule",
            targets: ["GameModule"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", from: "10.14.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.3")),
        .package(url: "https://github.com/furqoncreative/CoreModule.git", .upToNextMajor(from: "1.1.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GameModule",
            dependencies: [
                .product(name: "RealmSwift", package: "Realm"),
                "CoreModule",
                "Alamofire"
            ]),
        .testTarget(
            name: "GameModuleTests",
            dependencies: ["GameModule"]),
    ]
)