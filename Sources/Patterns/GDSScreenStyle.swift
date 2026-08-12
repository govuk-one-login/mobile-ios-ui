import UIKit

public struct GDSScreenStyle {
    let verticalAlignment: VerticalScreenAlignment
    let horizontalAlignment: UIStackView.Alignment
    let defaultVerticalPadding: VerticalPadding
    let defaultHorizontalPadding: HorizontalPadding
    let usesScrollView: Bool
    
    public init(
        verticalAlignment: VerticalScreenAlignment,
        horizontalAlignment: UIStackView.Alignment,
        defaultVerticalPadding: VerticalPadding = .vertical(8),
        defaultHorizontalPadding: HorizontalPadding = .horizontal(16),
        usesScrollView: Bool = true
    ) {
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.defaultVerticalPadding = defaultVerticalPadding
        self.defaultHorizontalPadding = defaultHorizontalPadding
        self.usesScrollView = usesScrollView
    }
}

extension GDSScreenStyle {
    public static var top: Self {
        GDSScreenStyle(
            verticalAlignment: .top,
            horizontalAlignment: .fill
        )
    }
    
    public static var centred: Self {
        GDSScreenStyle(
            verticalAlignment: .center,
            horizontalAlignment: .fill
        )
    }
    
    public static var centreLeading: Self {
        GDSScreenStyle(
            verticalAlignment: .center,
            horizontalAlignment: .leading
        )
    }
    
    public static var error: Self { .centred }
    
    public static var noScrollView: Self {
        GDSScreenStyle(
            verticalAlignment: .top,
            horizontalAlignment: .fill,
            usesScrollView: false
        )
    }
}

public enum VerticalScreenAlignment {
    case top, center
}
