#if canImport(SwiftUI) && canImport(UIKit)
import ObjCRuntimeUtilities
import SwiftUI
import UIKit

private let viewDeallocObservationKey = AssociatedObjectKey<DeallocObservation>()

public struct UIKitViewAdapter<WrappedView: UIView>: UIViewRepresentable {
    public typealias MakeView = () -> WrappedView
    public typealias UpdateView = (WrappedView) -> Void

    private let makeView: MakeView
    private let updateView: UpdateView
    private let onDealloc: (() -> Void)?

    public init(
        makeView: @escaping MakeView,
        updateView: @escaping UpdateView = { _ in },
        onDealloc: (() -> Void)? = nil
    ) {
        self.makeView = makeView
        self.updateView = updateView
        self.onDealloc = onDealloc
    }

    public func makeUIView(context _: Context) -> WrappedView {
        let view = makeView()
        if let onDealloc {
            let observation = DeallocObserver.observe(view, onDealloc)
            AssociatedObjects.set(observation, on: view, key: viewDeallocObservationKey)
        }
        return view
    }

    public func updateUIView(_ uiView: WrappedView, context _: Context) {
        updateView(uiView)
    }
}

public struct RuntimeInspectorPanel: View {
    private let info: RuntimeClassInfo

    public init(_ targetClass: AnyClass) {
        info = RuntimeInspector.inspect(targetClass)
    }

    public var body: some View {
        List {
            Section("Class") {
                Text(info.className)
                if let superclassName = info.superclassName {
                    Text("Superclass: \(superclassName)")
                }
            }

            Section("Methods") {
                ForEach(info.methods, id: \.name) { method in
                    Text(method.name)
                }
            }

            Section("Properties") {
                ForEach(info.properties, id: \.name) { property in
                    Text(property.name)
                }
            }
        }
    }
}
#endif
