# API Reference

## Associated Objects

`AssociatedObjectKey<Value>` creates a stable key for runtime-backed storage.

`AssociatedObjects` provides direct get, set, default, and remove helpers.

`@AssociatedObject` is a convenience property wrapper for class declarations.

## Swizzler

`Swizzler.exchangeInstanceMethods(on:_:)` exchanges two instance selectors and returns a `SwizzleReceipt`.

`Swizzler.exchangeClassMethods(on:_:)` does the same for class methods.

`SwizzleReceipt.undo()` exchanges the methods again to restore the previous behavior.

## DeallocObserver

`DeallocObserver.observe(_:queue:_:)` attaches a deallocation hook to an object and returns a `DeallocObservation`.

Retain the observation for as long as the hook should remain active. Call `cancel()` to remove it.

## KVOObservation

`KVOObservation<Object, Value>` wraps Foundation KVO with a typed key path and invalidation token.

The observed object must be an `NSObject` subclass and the observed member must be KVO-compliant, usually `@objc dynamic`.

## RuntimeInspector

`RuntimeInspector.inspect(_:)` returns a `RuntimeClassInfo`.

`RuntimeInspector.methods(of:)`, `properties(of:)`, and `ivars(of:)` return focused lists.

`RuntimeInspector.classNames(prefix:)` lists loaded Objective-C runtime classes.

## ObjCRuntimeUtilitiesUI

`UIKitViewAdapter` wraps a UIKit view in SwiftUI and can attach a deallocation callback.

`RuntimeInspectorPanel` displays runtime metadata in a SwiftUI `List`.
