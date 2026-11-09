import Foundation

/// Errors reported through `ScanningViewController`'s `errorHandler` when the
/// capture pipeline cannot be configured.
///
/// Each case identifies a distinct setup failure so a consumer can respond
/// appropriately (for example, distinguishing "no camera on this device" from
/// a permission problem). Permission denial and other failures thrown while
/// constructing the capture input are reported via `.inputUnavailable(_:)`,
/// which carries the underlying `AVFoundation` error.
public enum ScanningSetupError: Error {
    /// No capture device was available for the requested media type.
    case deviceUnavailable
    /// Constructing the capture input failed; carries the underlying error.
    /// On a real device this is where camera-permission denial surfaces.
    case inputUnavailable(Error)
    /// The capture session rejected the video input.
    case cannotAddInput
    /// The capture session rejected the video output.
    case cannotAddOutput
}
