public enum Action {
    case action(() -> Void)
    case asyncAction(() async -> Void)
}
