# What This Can and Cannot Do

## Can

- Store Swift values on Objective-C compatible objects through associated objects.
- Exchange Objective-C visible methods when both selectors exist.
- Observe object deallocation by attaching a retained token.
- Wrap KVO in a typed Swift object.
- Inspect Objective-C runtime metadata for classes, methods, properties, and ivars.
- Provide small SwiftUI/UIKit bridges that make runtime-backed UIKit behavior easier to demo.

## Cannot

- Make pure Swift structs, enums, or actors behave like Objective-C objects.
- Add Objective-C message-to-`nil` behavior to Swift.
- Recreate the C preprocessor or Objective-C macro system.
- Make private Apple selectors or classes safe to use.
- Guarantee that swizzling is appropriate for every app architecture.
- Bypass Swift access control, App Store review, sandboxing, or platform privacy rules.

## Tradeoffs

Runtime tools are most useful at integration boundaries: legacy UIKit, Objective-C SDKs, KVO-backed Foundation APIs, test harnesses, and debugging overlays.

They are a poor fit for normal app state, domain logic, or new code you fully control. Prefer Swift protocols, dependency injection, property wrappers, observation, and composition when those solve the problem.
