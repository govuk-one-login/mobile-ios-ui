import UIKit

@MainActor
public protocol ContentItem {
    var uiView: UIView { get }
}
