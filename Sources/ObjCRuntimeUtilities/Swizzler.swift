import Foundation
import ObjCRuntimeUtilitiesObjC
import ObjectiveC

public enum SwizzleError: Error, Equatable, LocalizedError {
    case missingOriginalSelector(String, String)
    case missingReplacementSelector(String, String)
    case exchangeFailed(String, String, String)

    public var errorDescription: String? {
        switch self {
        case let .missingOriginalSelector(selector, className):
            return "Missing original selector \(selector) on \(className)."
        case let .missingReplacementSelector(selector, className):
            return "Missing replacement selector \(selector) on \(className)."
        case let .exchangeFailed(original, replacement, className):
            return "Could not exchange \(original) with \(replacement) on \(className)."
        }
    }
}

public struct SwizzleReceipt {
    public enum Kind {
        case instance
        case `class`
    }

    public let className: String
    public let originalSelector: Selector
    public let replacementSelector: Selector
    public let kind: Kind

    private let targetClass: AnyClass

    init(
        targetClass: AnyClass,
        originalSelector: Selector,
        replacementSelector: Selector,
        kind: Kind
    ) {
        self.targetClass = targetClass
        self.className = NSStringFromClass(targetClass)
        self.originalSelector = originalSelector
        self.replacementSelector = replacementSelector
        self.kind = kind
    }

    public func undo() throws {
        switch kind {
        case .instance:
            _ = try Swizzler.exchangeInstanceMethods(
                on: targetClass,
                originalSelector,
                replacementSelector
            )
        case .class:
            _ = try Swizzler.exchangeClassMethods(
                on: targetClass,
                originalSelector,
                replacementSelector
            )
        }
    }
}

public enum Swizzler {
    @discardableResult
    public static func exchangeInstanceMethods(
        on targetClass: AnyClass,
        _ originalSelector: Selector,
        _ replacementSelector: Selector
    ) throws -> SwizzleReceipt {
        let className = NSStringFromClass(targetClass)

        guard class_getInstanceMethod(targetClass, originalSelector) != nil else {
            throw SwizzleError.missingOriginalSelector(
                NSStringFromSelector(originalSelector),
                className
            )
        }

        guard class_getInstanceMethod(targetClass, replacementSelector) != nil else {
            throw SwizzleError.missingReplacementSelector(
                NSStringFromSelector(replacementSelector),
                className
            )
        }

        guard ORUExchangeInstanceMethods(targetClass, originalSelector, replacementSelector) else {
            throw SwizzleError.exchangeFailed(
                NSStringFromSelector(originalSelector),
                NSStringFromSelector(replacementSelector),
                className
            )
        }

        return SwizzleReceipt(
            targetClass: targetClass,
            originalSelector: originalSelector,
            replacementSelector: replacementSelector,
            kind: .instance
        )
    }

    @discardableResult
    public static func exchangeClassMethods(
        on targetClass: AnyClass,
        _ originalSelector: Selector,
        _ replacementSelector: Selector
    ) throws -> SwizzleReceipt {
        let className = NSStringFromClass(targetClass)
        guard let metaclass = object_getClass(targetClass) else {
            throw SwizzleError.exchangeFailed(
                NSStringFromSelector(originalSelector),
                NSStringFromSelector(replacementSelector),
                className
            )
        }

        guard class_getInstanceMethod(metaclass, originalSelector) != nil else {
            throw SwizzleError.missingOriginalSelector(
                NSStringFromSelector(originalSelector),
                className
            )
        }

        guard class_getInstanceMethod(metaclass, replacementSelector) != nil else {
            throw SwizzleError.missingReplacementSelector(
                NSStringFromSelector(replacementSelector),
                className
            )
        }

        guard ORUExchangeClassMethods(targetClass, originalSelector, replacementSelector) else {
            throw SwizzleError.exchangeFailed(
                NSStringFromSelector(originalSelector),
                NSStringFromSelector(replacementSelector),
                className
            )
        }

        return SwizzleReceipt(
            targetClass: targetClass,
            originalSelector: originalSelector,
            replacementSelector: replacementSelector,
            kind: .class
        )
    }
}
