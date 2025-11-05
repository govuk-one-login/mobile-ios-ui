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
    public static var top: Self {
        GDSScreenStyle(
            verticalAlignment: .top,
            horizontalAlignment: .fill
        )
    }
    
    @available(*, deprecated, renamed: "top", message: "Will be removed December 2025 - please use `top` style instead")
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
    
    @available(*, deprecated, message: "Will be removed December 2025 - please use `top` style instead")
    public static var topLeading: Self {
        GDSScreenStyle(
            verticalAlignment: .top,
            horizontalAlignment: .leading
        )
    }
    
    public static var centreLeading: Self {
        GDSScreenStyle(
            verticalAlignment: .center,
            horizontalAlignment: .leading
        )
    }
    
    public static var error: Self { .centred }
}

public enum VerticalScreenAlignment {
    case top, center
}
