extension DesignSystem {
    public enum Action {
        case action(() -> Void)
        case asyncAction(() async -> Void)
        
        public func perform() {
            switch self {
            case .action(let action):
                action()
            case .asyncAction:
                assertionFailure("Use performAsync() for async actions")
            }
        }
        
        public func performAsync() async {
            switch self {
            case .action(let action):
                action()
            case .asyncAction(let action):
                await action()
            }
        }
    }
}

public typealias ButtonAction = DesignSystem.Action
