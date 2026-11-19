import Vision

/// A `VNRequest` whose `results` can be stubbed, used to drive `detectedBarcode`.
final class MockBarcodeRequest: VNRequest {
    private var mockResults: [VNObservation]?

    override var results: [VNObservation]? {
        mockResults
    }

    convenience init(results: [VNObservation]?) {
        self.init()
        self.mockResults = results
    }
}

/// A `VNBarcodeObservation` with a stubbed payload string.
final class MockBarcodeObservation: VNBarcodeObservation {
    private var mockValue: String?

    override var payloadStringValue: String? {
        mockValue
    }

    convenience init(_ mockValue: String) {
        self.init()
        self.mockValue = mockValue
    }
}

/// A `VNDetectBarcodesRequest` that records the completion handler it was built with
/// and whether it was cancelled, so tests can assert on request construction.
final class MockDetectBarcodeRequest: VNDetectBarcodesRequest {
    let requestHandler: VNRequestCompletionHandler?
    private(set) var wasCancelled: Bool = false

    override init(completionHandler: VNRequestCompletionHandler? = nil) {
        self.requestHandler = completionHandler
        super.init(completionHandler: completionHandler)
    }

    override func cancel() {
        wasCancelled = true
        super.cancel()
    }
}
