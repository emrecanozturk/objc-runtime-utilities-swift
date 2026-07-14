# App Store Safety

This package uses public APIs:

- Objective-C runtime functions from `<objc/runtime.h>`
- Foundation KVO
- Swift Package Manager
- SwiftUI and UIKit public APIs where available

Public runtime APIs are not automatically safe in every use. App Store-safe usage means:

- no private selectors
- no private classes
- no undocumented UIKit/AppKit internals
- no assumptions about Apple framework implementation details
- no global swizzling without tests and a clear rollback plan

## Recommended Use

- Extension-backed associated storage on your own objects.
- KVO wrappers for documented KVO-compliant Foundation properties.
- Runtime inspection for diagnostics, debugging, or documentation.
- Narrow swizzling for legacy integration points you own and test.

## Avoid

- Swizzling Apple framework methods to alter app policy behavior.
- Depending on private class names found through runtime inspection.
- Using runtime tricks to bypass platform permissions or review rules.
- Making runtime mutation the default architecture for new code.
