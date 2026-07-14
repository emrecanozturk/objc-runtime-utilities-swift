import ObjCRuntimeUtilities
import XCTest

final class SwizzlerTests: XCTestCase {
    private final class Subject: NSObject {
        @objc dynamic func greeting() -> String {
            "original"
        }

        @objc dynamic func oru_replacementGreeting() -> String {
            "replacement"
        }
    }

    func testSwizzlerExchangesAndRestoresInstanceMethods() throws {
        let subject = Subject()
        XCTAssertEqual(subject.greeting(), "original")

        let receipt = try Swizzler.exchangeInstanceMethods(
            on: Subject.self,
            #selector(Subject.greeting),
            #selector(Subject.oru_replacementGreeting)
        )
        defer { try? receipt.undo() }

        XCTAssertEqual(subject.greeting(), "replacement")

        try receipt.undo()
        XCTAssertEqual(subject.greeting(), "original")
    }
}
