# SwiftUI and UIKit Bridges

`ObjCRuntimeUtilitiesUI` is intentionally small. It is a demo and adapter layer for places where SwiftUI code needs to hold or inspect UIKit objects.

## UIKitViewAdapter

`UIKitViewAdapter` wraps a UIKit view in SwiftUI:

```swift
UIKitViewAdapter {
    UILabel()
} updateView: { label in
    label.text = "Runtime backed"
} onDealloc: {
    print("Label released")
}
```

The deallocation observation is retained as an associated object on the UIKit view.

## RuntimeInspectorPanel

`RuntimeInspectorPanel(UIViewController.self)` renders runtime metadata in a SwiftUI list.

It is useful for demos and debugging tools, not for production UI by default.
