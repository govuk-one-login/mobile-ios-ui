import UIKit

@MainActor
public final class EnableState {
    public var isEnabled: Bool {
        didSet { onChange?(isEnabled) }
    }
    var onChange: ((Bool) -> Void)?

    public init(_ isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}
