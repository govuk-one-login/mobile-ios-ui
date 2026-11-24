import Foundation

/// Runs a work item after a delay in seconds. Components take one of these so tests can control time.
typealias DelayedScheduler = (_ delay: TimeInterval, _ workItem: DispatchWorkItem) -> Void

enum DelayedSchedulers {
    static func mainQueue(delay: TimeInterval, workItem: DispatchWorkItem) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}
