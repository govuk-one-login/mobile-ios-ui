import UIKit

public enum HorizontalPadding {
    case horizontal(CGFloat)
    case leading(CGFloat)
    case trailing(CGFloat)
    
    var leadingPadding: CGFloat {
        switch self {
        case .horizontal(let cGFloat), .leading(let cGFloat):
            cGFloat
        case .trailing:
                .zero
        }
    }
    
    var trailingPadding: CGFloat {
        switch self {
        case .horizontal(let cGFloat), .trailing(let cGFloat):
            cGFloat
        case .leading:
                .zero
        }
    }
}

public enum VerticalPadding {
    case vertical(CGFloat)
    case top(CGFloat)
    case bottom(CGFloat)
    
    var topPadding: CGFloat {
        switch self {
        case .vertical(let cGFloat), .top(let cGFloat):
            cGFloat
        case .bottom:
                .zero
        }
    }
    
    var bottomPadding: CGFloat {
        switch self {
        case .vertical(let cGFloat), .bottom(let cGFloat):
            cGFloat
        case .top:
                .zero
        }
    }
}

