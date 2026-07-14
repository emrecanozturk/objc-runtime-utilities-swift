import Foundation
import ObjectiveC

public final class AssociatedObjectKey<Value>: @unchecked Sendable {
    private let rawPointer: UnsafeMutableRawPointer

    public init() {
        rawPointer = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1)
    }

    deinit {
        rawPointer.deallocate()
    }

    fileprivate var pointer: UnsafeRawPointer {
        UnsafeRawPointer(rawPointer)
    }
}

public enum AssociatedObjects {
    public static func get<Value>(
        _ object: AnyObject,
        key: AssociatedObjectKey<Value>
    ) -> Value? {
        objc_getAssociatedObject(object, key.pointer) as? Value
    }

    public static func set<Value>(
        _ value: Value?,
        on object: AnyObject,
        key: AssociatedObjectKey<Value>,
        policy: AssociationPolicy = .retainNonatomic
    ) {
        objc_setAssociatedObject(object, key.pointer, value, policy.objcPolicy)
    }

    public static func value<Value>(
        on object: AnyObject,
        key: AssociatedObjectKey<Value>,
        default makeDefault: @autoclosure () -> Value,
        policy: AssociationPolicy = .retainNonatomic
    ) -> Value {
        if let existing: Value = get(object, key: key) {
            return existing
        }

        let value = makeDefault()
        set(value, on: object, key: key, policy: policy)
        return value
    }

    public static func remove<Value>(
        from object: AnyObject,
        key: AssociatedObjectKey<Value>
    ) {
        objc_setAssociatedObject(object, key.pointer, nil, .OBJC_ASSOCIATION_ASSIGN)
    }
}

@propertyWrapper
public struct AssociatedObject<Value> {
    private let key: AssociatedObjectKey<Value>
    private let policy: AssociationPolicy
    private let makeDefault: (() -> Value)?

    public init(
        _ key: AssociatedObjectKey<Value>,
        policy: AssociationPolicy = .retainNonatomic
    ) {
        self.key = key
        self.policy = policy
        makeDefault = nil
    }

    public init(
        wrappedValue: @autoclosure @escaping () -> Value,
        _ key: AssociatedObjectKey<Value>,
        policy: AssociationPolicy = .retainNonatomic
    ) {
        self.key = key
        self.policy = policy
        makeDefault = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            preconditionFailure("@AssociatedObject must be read from a class instance.")
        }
        set {
            _ = newValue
            preconditionFailure("@AssociatedObject must be written from a class instance.")
        }
    }

    public static subscript<EnclosingSelf: AnyObject>(
        _enclosingInstance object: EnclosingSelf,
        wrapped _: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, AssociatedObject<Value>>
    ) -> Value {
        get {
            let wrapper = object[keyPath: storageKeyPath]
            if let existing: Value = AssociatedObjects.get(object, key: wrapper.key) {
                return existing
            }

            guard let makeDefault = wrapper.makeDefault else {
                preconditionFailure("@AssociatedObject has no stored value and no default value.")
            }

            let value = makeDefault()
            AssociatedObjects.set(value, on: object, key: wrapper.key, policy: wrapper.policy)
            return value
        }
        set {
            let wrapper = object[keyPath: storageKeyPath]
            AssociatedObjects.set(newValue, on: object, key: wrapper.key, policy: wrapper.policy)
        }
    }
}
