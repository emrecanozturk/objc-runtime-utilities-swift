# API Reference

## Associated Objects

Use `AssociatedObjectKey<Value>` plus `AssociatedObjects.get` and `AssociatedObjects.set`.

## Swizzler

Use `Swizzler.exchangeInstanceMethods` or `Swizzler.exchangeClassMethods`. Keep the returned `SwizzleReceipt` if you need to undo the exchange.

## Dealloc Observer

Use `DeallocObserver.observe` and retain the returned `DeallocObservation`.

## KVO

Use `KVOObservation<Object, Value>` with KVO-compliant `NSObject` subclasses.

## Runtime Inspector

Use `RuntimeInspector.inspect(_:)` to inspect class metadata.
