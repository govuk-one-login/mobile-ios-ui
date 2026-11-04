import Foundation

/// Thread-safe recorder for the scanner's `@Sendable` error handler, which may be
/// invoked from a background queue. Lets tests assert call count / captured error
/// without mutating a captured `var` from a `@Sendable` closure.
final class ErrorHandlerRecorder: @unchecked Sendable {
    private let lock = NSLock()
    private var _callCount = 0
    private var _lastError: Error?

    var callCount: Int {
        lock.withLock { _callCount }
    }

    var lastError: Error? {
        lock.withLock { _lastError }
    }

    func record(_ error: Error?) {
        lock.withLock {
            _callCount += 1
            _lastError = error
        }
    }

    /// Convenience to pass directly as the scanner's `errorHandler`.
    var handler: @Sendable (Error?) -> Void {
        { [weak self] error in self?.record(error) }
    }
}
