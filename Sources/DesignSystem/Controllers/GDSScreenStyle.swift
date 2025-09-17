import UIKit

public struct GDSScreenStyle {
    let verticalAlignment: VerticalScreenAlignment
    let horizontalAlignment: UIStackView.Alignment
    let defaultVerticalPadding: VerticalPadding
    let defaultHorizontalPadding: HorizontalPadding
    
    public init(
        verticalAlignment: VerticalScreenAlignment,
        horizontalAlignment: UIStackView.Alignment,
        defaultVerticalPadding: VerticalPadding = .vertical(8),
        defaultHorizontalPadding: HorizontalPadding = .horizontal(16)
    ) {
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.defaultVerticalPadding = defaultVerticalPadding
        self.defaultHorizontalPadding = defaultHorizontalPadding
    }
}

extension GDSScreenStyle {
    public static var topCentred: Self {
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
    
    public static var topLeadingAligned: Self {
        GDSScreenStyle(
            verticalAlignment: .top,
            horizontalAlignment: .leading
        )
    }
    
    public static var centreLeadingAligned: Self {
        GDSScreenStyle(
            verticalAlignment: .center,
            horizontalAlignment: .leading
        )
    }
}

public enum VerticalScreenAlignment {
    case top, center
}
