import ObjCRuntimeUtilities
import XCTest

final class DeallocObserverTests: XCTestCase {
    func testObserverFiresWhenObjectDeallocates() {
        let didDeallocate = expectation(description: "object deallocated")
        var observation: DeallocObservation?

        autoreleasepool {
            let object = NSObject()
            observation = DeallocObserver.observe(object) {
                didDeallocate.fulfill()
            }
            XCTAssertNotNil(observation)
        }

        wait(for: [didDeallocate], timeout: 1.0)
        observation?.cancel()
    }

    func testCancelledObserverDoesNotFire() {
        let didDeallocate = expectation(description: "object deallocated")
        didDeallocate.isInverted = true

        autoreleasepool {
            let object = NSObject()
            let observation = DeallocObserver.observe(object) {
                didDeallocate.fulfill()
            }
            observation.cancel()
        }

        wait(for: [didDeallocate], timeout: 0.2)
    }
}
