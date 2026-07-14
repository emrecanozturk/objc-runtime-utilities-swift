import ObjCRuntimeUtilities
import XCTest

final class AssociatedObjectTests: XCTestCase {
    private final class Host: NSObject {
        static let nicknameKey = AssociatedObjectKey<String>()

        @AssociatedObject(Host.nicknameKey)
        var nickname = "guest"
    }

    func testAssociatedObjectsStoreValuesPerObject() {
        let key = AssociatedObjectKey<Int>()
        let first = NSObject()
        let second = NSObject()

        AssociatedObjects.set(42, on: first, key: key)
        AssociatedObjects.set(7, on: second, key: key)

        XCTAssertEqual(AssociatedObjects.get(first, key: key), 42)
        XCTAssertEqual(AssociatedObjects.get(second, key: key), 7)
    }

    func testAssociatedObjectPropertyWrapperUsesDefaultAndPersists() {
        let host = Host()

        XCTAssertEqual(host.nickname, "guest")

        host.nickname = "runtime"
        XCTAssertEqual(host.nickname, "runtime")
    }
}
