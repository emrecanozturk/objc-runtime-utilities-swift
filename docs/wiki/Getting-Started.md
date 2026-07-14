# Getting Started

Add the package:

```text
https://github.com/emrecanozturk/objc-runtime-utilities-swift
```

Import the main module:

```swift
import ObjCRuntimeUtilities
```

Use associated objects when you need extension-backed storage on Objective-C compatible objects:

```swift
private let key = AssociatedObjectKey<String>()

extension NSObject {
    var runtimeName: String? {
        get { AssociatedObjects.get(self, key: key) }
        set { AssociatedObjects.set(newValue, on: self, key: key) }
    }
}
```
