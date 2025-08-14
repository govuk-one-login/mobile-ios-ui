import UIKit

@MainActor
public protocol ContentItem {
    var verticalPadding: VerticalPadding? { get }
    var horizontalPadding: HorizontalPadding? { get }
    var uiView: UIView { get }
}

extension ContentItem {
    public var verticalPadding: VerticalPadding? {
        nil
    }
    
    public var horizontalPadding: HorizontalPadding? {
        nil
    }
}

public enum HorizontalPadding {
    case horizontal(CGFloat)
    case leading(CGFloat)
    case trailing(CGFloat)
    
    var leadingPadding: CGFloat? {
        switch self {
        case .horizontal(let cGFloat), .leading(let cGFloat):
            cGFloat
        case .trailing:
            nil
        }
    }
    
    var trailingPadding: CGFloat? {
        switch self {
        case .horizontal(let cGFloat), .trailing(let cGFloat):
            cGFloat
        case .leading:
            nil
        }
    }
}

public enum VerticalPadding {
    case vertical(CGFloat)
    case top(CGFloat)
    case bottom(CGFloat)
    
    var topPadding: CGFloat? {
        switch self {
        case .vertical(let cGFloat), .top(let cGFloat):
            cGFloat
        case .bottom:
            nil
        }
    }
    
    var bottomPadding: CGFloat? {
        switch self {
        case .vertical(let cGFloat), .bottom(let cGFloat):
            cGFloat
        case .top:
            nil
        }
    }
}
