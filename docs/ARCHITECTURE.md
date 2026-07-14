# Architecture

The package intentionally separates low-level runtime calls from the Swift API.

```text
ObjCRuntimeUtilitiesObjC
  ORUObjCRuntimeShims.h/.m
  small C/Objective-C wrappers around method exchange and class-name lookup

ObjCRuntimeUtilities
  Swift public API for associated objects, swizzling, dealloc observation,
  KVO, and runtime inspection

ObjCRuntimeUtilitiesUI
  SwiftUI/UIKit examples and adapters

RuntimeInspectorCLI
  command line example for listing runtime classes
```

Swift Package Manager does not mix Swift and Objective-C files inside one target, so the Objective-C shim is its own target and the Swift module depends on it.

The shim should stay small. Any API that can be safely expressed in Swift belongs in `ObjCRuntimeUtilities`.
