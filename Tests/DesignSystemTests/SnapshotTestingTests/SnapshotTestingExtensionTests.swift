import Testing

@MainActor
struct SnapshotTestingExtensionTests {
    @Test("ViewController Snapshot Testing Extension")
    func viewControllerSnapshotTest() {
        let vc = MockViewController()

        vc.assertSnapshot()
    }
}
