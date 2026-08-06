import Foundation

@MainActor
public protocol BaseViewModel {
    var rightBarButtonTitle: GDSLocalisedString? { get }
    var backButtonTitle: GDSLocalisedString? { get }
    var backButtonIsHidden: Bool { get }
    
    var didAppear: DesignSystem.Action? { get }
    var didDismiss: DesignSystem.Action? { get }

    /// Declarative configurations for the left navigation bar buttons.
    /// Return `nil` for no left bar buttons (default).
    var leftBarButtons: [DesignSystem.NavigationBarButton]? { get }

    /// Declarative configurations for the right navigation bar buttons.
    /// Supports both simple action buttons and menu buttons.
    /// Return `nil` to fall back to the legacy `rightBarButtonTitle` behaviour.
    var rightBarButtons: [DesignSystem.NavigationBarButton]? { get }
}

extension BaseViewModel {
    public var leftBarButtons: [DesignSystem.NavigationBarButton]? { nil }
    public var rightBarButtons: [DesignSystem.NavigationBarButton]? { nil }
}
