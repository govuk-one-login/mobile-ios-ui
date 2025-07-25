extension Task where Success == Never, Failure == Never {
    public static func sleep(seconds: Double) async throws {
        try await self.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
