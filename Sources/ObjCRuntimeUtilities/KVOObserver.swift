import Foundation

public final class KVOObservation<Object: NSObject, Value> {
    private var observation: NSKeyValueObservation?

    public init(
        object: Object,
        keyPath: KeyPath<Object, Value>,
        options: NSKeyValueObservingOptions = [.new],
        queue: DispatchQueue? = nil,
        handler: @escaping (Object, NSKeyValueObservedChange<Value>) -> Void
    ) {
        observation = object.observe(keyPath, options: options) { observedObject, change in
            if let queue {
                queue.async {
                    handler(observedObject, change)
                }
            } else {
                handler(observedObject, change)
            }
        }
    }

    deinit {
        invalidate()
    }

    public func invalidate() {
        observation?.invalidate()
        observation = nil
    }
}
