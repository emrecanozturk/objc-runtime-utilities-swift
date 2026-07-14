import ObjCRuntimeUtilities
import XCTest

final class RuntimeInspectorTests: XCTestCase {
    private final class Subject: NSObject {
        @objc dynamic var title: String = "runtime"

        @objc dynamic func ping() -> String {
            "pong"
        }
    }

    func testRuntimeInspectorFindsMethodsAndProperties() {
        let info = RuntimeInspector.inspect(Subject.self)

        XCTAssertTrue(info.methods.contains { $0.name == "ping" })
        XCTAssertTrue(info.properties.contains { $0.name == "title" })
        XCTAssertEqual(info.superclassName, "NSObject")
    }

    func testRuntimeInspectorCanListClassNamesByPrefix() {
        let names = RuntimeInspector.classNames(prefix: "NS")

        XCTAssertTrue(names.contains("NSObject"))
    }
}
