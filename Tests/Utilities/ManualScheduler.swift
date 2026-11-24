@testable import DesignSystem
import Foundation

/// Captures scheduled work so tests decide when, and whether, it runs.
final class ManualScheduler {
    private var scheduled: [(delay: TimeInterval, item: DispatchWorkItem)] = []
    
    var delays: [TimeInterval] { scheduled.map(\.delay) }
    
    func schedule(delay: TimeInterval, item: DispatchWorkItem) {
        scheduled.append((delay, item))
    }
    
    func run(delay: TimeInterval) {
        scheduled.filter { $0.delay == delay }.forEach { $0.item.perform() }
    }
}
