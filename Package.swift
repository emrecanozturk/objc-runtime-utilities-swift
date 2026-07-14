// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ObjCRuntimeUtilities",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "ObjCRuntimeUtilities",
            targets: ["ObjCRuntimeUtilities"]
        ),
        .library(
            name: "ObjCRuntimeUtilitiesUI",
            targets: ["ObjCRuntimeUtilitiesUI"]
        ),
        .executable(
            name: "runtime-inspector",
            targets: ["RuntimeInspectorCLI"]
        )
    ],
    targets: [
        .target(
            name: "ObjCRuntimeUtilitiesObjC",
            publicHeadersPath: "include"
        ),
        .target(
            name: "ObjCRuntimeUtilities",
            dependencies: ["ObjCRuntimeUtilitiesObjC"]
        ),
        .target(
            name: "ObjCRuntimeUtilitiesUI",
            dependencies: ["ObjCRuntimeUtilities"]
        ),
        .executableTarget(
            name: "RuntimeInspectorCLI",
            dependencies: ["ObjCRuntimeUtilities"]
        ),
        .testTarget(
            name: "ObjCRuntimeUtilitiesTests",
            dependencies: ["ObjCRuntimeUtilities"]
        )
    ]
)
