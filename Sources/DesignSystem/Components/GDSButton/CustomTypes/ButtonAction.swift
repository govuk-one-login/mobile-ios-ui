public enum ButtonAction {
    case action(() -> Void)
    case asyncAction(() async -> Void)
}
