import ObjCRuntimeUtilities
import XCTest

final class KVOObserverTests: XCTestCase {
    private final class Host: NSObject {
        @objc dynamic var title: String = "before"
    }

    func testKVOObservationReceivesTypedChanges() {
        let host = Host()
        let didChange = expectation(description: "title changed")

        let observation = KVOObservation(
            object: host,
            keyPath: \.title,
            options: [.new]
        ) { _, change in
            if change.newValue == "after" {
                didChange.fulfill()
            }
        }

        host.title = "after"

        wait(for: [didChange], timeout: 1.0)
        observation.invalidate()
    }
}
