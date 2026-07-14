import Foundation
import ObjCRuntimeUtilitiesObjC
import ObjectiveC

public struct RuntimeClassInfo: Equatable, Codable {
    public let className: String
    public let superclassName: String?
    public let methods: [RuntimeMethodInfo]
    public let classMethods: [RuntimeMethodInfo]
    public let properties: [RuntimePropertyInfo]
    public let ivars: [RuntimeIvarInfo]
}

public struct RuntimeMethodInfo: Equatable, Codable {
    public let name: String
    public let typeEncoding: String?
    public let isClassMethod: Bool
}

public struct RuntimePropertyInfo: Equatable, Codable {
    public let name: String
    public let attributes: String?
}

public struct RuntimeIvarInfo: Equatable, Codable {
    public let name: String
    public let typeEncoding: String?
    public let offset: Int
}

public enum RuntimeInspector {
    public static func inspect(_ targetClass: AnyClass) -> RuntimeClassInfo {
        RuntimeClassInfo(
            className: NSStringFromClass(targetClass),
            superclassName: class_getSuperclass(targetClass).map(NSStringFromClass),
            methods: methods(of: targetClass, includeClassMethods: false),
            classMethods: methods(of: targetClass, includeClassMethods: true),
            properties: properties(of: targetClass),
            ivars: ivars(of: targetClass)
        )
    }

    public static func methods(
        of targetClass: AnyClass,
        includeClassMethods: Bool = false
    ) -> [RuntimeMethodInfo] {
        let inspectedClass: AnyClass
        if includeClassMethods {
            guard let metaclass = object_getClass(targetClass) else {
                return []
            }
            inspectedClass = metaclass
        } else {
            inspectedClass = targetClass
        }

        var count: UInt32 = 0
        guard let list = class_copyMethodList(inspectedClass, &count) else {
            return []
        }
        defer { free(list) }

        return (0..<Int(count))
            .map { index in
                let method = list[index]
                return RuntimeMethodInfo(
                    name: NSStringFromSelector(method_getName(method)),
                    typeEncoding: method_getTypeEncoding(method).map { String(cString: $0) },
                    isClassMethod: includeClassMethods
                )
            }
            .sorted { $0.name < $1.name }
    }

    public static func properties(of targetClass: AnyClass) -> [RuntimePropertyInfo] {
        var count: UInt32 = 0
        guard let list = class_copyPropertyList(targetClass, &count) else {
            return []
        }
        defer { free(list) }

        return (0..<Int(count))
            .map { index in
                let property = list[index]
                return RuntimePropertyInfo(
                    name: String(cString: property_getName(property)),
                    attributes: property_getAttributes(property).map { String(cString: $0) }
                )
            }
            .sorted { $0.name < $1.name }
    }

    public static func ivars(of targetClass: AnyClass) -> [RuntimeIvarInfo] {
        var count: UInt32 = 0
        guard let list = class_copyIvarList(targetClass, &count) else {
            return []
        }
        defer { free(list) }

        return (0..<Int(count))
            .compactMap { index in
                let ivar = list[index]
                guard let rawName = ivar_getName(ivar) else {
                    return nil
                }

                return RuntimeIvarInfo(
                    name: String(cString: rawName),
                    typeEncoding: ivar_getTypeEncoding(ivar).map { String(cString: $0) },
                    offset: ivar_getOffset(ivar)
                )
            }
            .sorted { $0.name < $1.name }
    }

    public static func classNames(prefix: String? = nil) -> [String] {
        ORUCopyClassNamesWithPrefix(prefix)
    }
}
