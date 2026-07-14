import Foundation

private let deallocObservationBagKey = AssociatedObjectKey<DeallocObservationBag>()

public final class DeallocObservation {
    private let token: DeallocObservationToken

    init(token: DeallocObservationToken) {
        self.token = token
    }

    deinit {
        cancel()
    }

    public func cancel() {
        token.cancel()
    }
}

public enum DeallocObserver {
    @discardableResult
    public static func observe(
        _ object: AnyObject,
        queue: DispatchQueue? = nil,
        _ handler: @escaping () -> Void
    ) -> DeallocObservation {
        let bag = AssociatedObjects.value(
            on: object,
            key: deallocObservationBagKey,
            default: DeallocObservationBag()
        )
        let token = DeallocObservationToken(queue: queue, handler: handler)
        token.bag = bag
        bag.insert(token)
        return DeallocObservation(token: token)
    }
}

final class DeallocObservationBag {
    private let lock = NSLock()
    private var tokens: [UUID: DeallocObservationToken] = [:]

    deinit {
        let currentTokens = lock.withLock { () -> [DeallocObservationToken] in
            let snapshot = Array(tokens.values)
            tokens.removeAll()
            return snapshot
        }
        currentTokens.forEach { $0.fireIfNeeded() }
    }

    func insert(_ token: DeallocObservationToken) {
        lock.withLock {
            tokens[token.id] = token
        }
    }

    func remove(_ token: DeallocObservationToken) {
        lock.withLock {
            tokens[token.id] = nil
        }
    }
}

final class DeallocObservationToken {
    let id = UUID()
    weak var bag: DeallocObservationBag?

    private let lock = NSLock()
    private let queue: DispatchQueue?
    private let handler: () -> Void
    private var didFinish = false

    init(queue: DispatchQueue?, handler: @escaping () -> Void) {
        self.queue = queue
        self.handler = handler
    }

    deinit {
        fireIfNeeded()
    }

    func cancel() {
        let shouldRemove = lock.withLock { () -> Bool in
            guard !didFinish else {
                return false
            }
            didFinish = true
            return true
        }

        if shouldRemove {
            bag?.remove(self)
        }
    }

    func fireIfNeeded() {
        let shouldFire = lock.withLock { () -> Bool in
            guard !didFinish else {
                return false
            }
            didFinish = true
            return true
        }

        guard shouldFire else {
            return
        }

        if let queue {
            queue.async(execute: handler)
        } else {
            handler()
        }
    }
}
