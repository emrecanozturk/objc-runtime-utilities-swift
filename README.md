# ObjC Runtime Utilities for Swift and SwiftUI

[![CI](https://github.com/emrecanozturk/objc-runtime-utilities-swift/actions/workflows/ci.yml/badge.svg)](https://github.com/emrecanozturk/objc-runtime-utilities-swift/actions/workflows/ci.yml)
[![CodeQL](https://github.com/emrecanozturk/objc-runtime-utilities-swift/actions/workflows/codeql.yml/badge.svg)](https://github.com/emrecanozturk/objc-runtime-utilities-swift/actions/workflows/codeql.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Small, documented, App Store-safe wrappers around the Objective-C runtime features that Swift apps still sometimes need.

The package keeps the sharp runtime APIs in a tiny Objective-C shim target and exposes a Swift-first API for associated objects, method swizzling, deallocation hooks, KVO, runtime inspection, and SwiftUI/UIKit bridge examples.

## Why

Objective-C runtime APIs are powerful, public, and easy to misuse. Swift gives you better type safety, but some Apple-platform work still needs runtime behavior: extension-backed storage, lifecycle observation, KVO interop, UIKit instrumentation, or careful method exchange in legacy seams.

This package makes those operations explicit, testable, and documented.

## Features

- `AssociatedObjectKey`, `AssociatedObjects`, and `@AssociatedObject`
- `Swizzler.exchangeInstanceMethods` and reversible `SwizzleReceipt`
- `DeallocObserver.observe`
- `KVOObservation<Object, Value>`
- `RuntimeInspector.inspect`, method/property/ivar listing, and class-name search
- `ObjCRuntimeUtilitiesUI` with a small SwiftUI/UIKit bridge surface
- `runtime-inspector` command line example

## Installation

Add the package in Xcode:

```text
https://github.com/emrecanozturk/objc-runtime-utilities-swift
```

Or in `Package.swift`:

```swift
.package(
    url: "https://github.com/emrecanozturk/objc-runtime-utilities-swift",
    from: "0.1.0"
)
```

Then add one of the products:

```swift
.product(name: "ObjCRuntimeUtilities", package: "objc-runtime-utilities-swift")
.product(name: "ObjCRuntimeUtilitiesUI", package: "objc-runtime-utilities-swift")
```

## Quick Start

### Associated Objects

```swift
import ObjCRuntimeUtilities
import UIKit

private let trackingIDKey = AssociatedObjectKey<String>()

extension UIViewController {
    var trackingID: String? {
        get { AssociatedObjects.get(self, key: trackingIDKey) }
        set { AssociatedObjects.set(newValue, on: self, key: trackingIDKey) }
    }
}
```

### Property Wrapper

```swift
final class RuntimeBackedModel: NSObject {
    private static let nameKey = AssociatedObjectKey<String>()

    @AssociatedObject(RuntimeBackedModel.nameKey)
    var name = "Untitled"
}
```

### Swizzling

```swift
let receipt = try Swizzler.exchangeInstanceMethods(
    on: UIViewController.self,
    #selector(UIViewController.viewDidAppear(_:)),
    #selector(UIViewController.oru_viewDidAppear(_:))
)

try receipt.undo()
```

Use swizzling narrowly, test it, and prefer normal Swift composition when you control the code.

### Dealloc Observer

```swift
let observation = DeallocObserver.observe(viewController) {
    print("View controller released")
}
```

Retain the returned `DeallocObservation` for as long as the hook should stay active.

### KVO

```swift
let observation = KVOObservation(
    object: playerItem,
    keyPath: \.status,
    options: [.initial, .new]
) { item, change in
    print(item, change.newValue as Any)
}
```

### Runtime Inspection

```swift
let info = RuntimeInspector.inspect(UIViewController.self)
print(info.methods.map(\.name))
```

## What This Can and Cannot Do

It can wrap public Objective-C runtime APIs in a safer Swift API.

It cannot make Swift behave exactly like Objective-C. It does not add Objective-C message-to-`nil` semantics, runtime mutation for pure Swift value types, private API access, or a preprocessor macro system.

See [What This Can and Cannot Do](docs/CAN-CANNOT.md) for the full boundary.

## App Store Safety

The package uses public Objective-C runtime and Foundation APIs. App Store safety still depends on how you use it:

- Do not reference private Apple classes or selectors.
- Do not depend on undocumented UIKit/AppKit internals.
- Keep swizzling behind small, tested integration points.
- Prefer normal Swift APIs when runtime behavior is not required.

See [App Store Safety](docs/APP-STORE-SAFETY.md).

## Package Layout

```text
Sources/
  ObjCRuntimeUtilitiesObjC/   Objective-C runtime shim
  ObjCRuntimeUtilities/       Swift public API
  ObjCRuntimeUtilitiesUI/     SwiftUI/UIKit examples and adapters
  RuntimeInspectorCLI/        Small executable example
Tests/
  ObjCRuntimeUtilitiesTests/
Examples/
  SwiftUIRuntimeExample/
docs/
  wiki/
```

## Local Checks

```bash
swift test
bash scripts/check-public-ready.sh
bash scripts/check-docs.sh
bash scripts/release-local.sh
```

## Documentation

- [API Reference](docs/API.md)
- [Architecture](docs/ARCHITECTURE.md)
- [SwiftUI and UIKit Bridges](docs/SWIFTUI-BRIDGES.md)
- [Release Checklist](docs/RELEASE.md)
- [Roadmap](ROADMAP.md)

## License

MIT. See [LICENSE](LICENSE).
