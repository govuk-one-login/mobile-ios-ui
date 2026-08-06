import UIKit

/// Configuration type for navigation bar buttons.
/// Use this to declaratively define left or right bar buttons from a view model.
extension DesignSystem {
    @MainActor
    public struct NavigationBarButton {
        public let content: Content
        public let action: (@MainActor () -> Void)?
        public let accessibilityIdentifier: String?

        public init(
            content: Content,
            action: (@MainActor () -> Void)?,
            accessibilityIdentifier: String?
        ) {
            self.content = content
            self.action = action
            self.accessibilityIdentifier = accessibilityIdentifier
        }

        /// A simple bar button with a title or image and an action closure.
        /// When both `title` and `image` are provided, image takes visual precedence
        /// in the navigation bar — the title is used as the accessibility label.
        public static func button(
            title: String? = nil,
            image: UIImage? = nil,
            style: UIBarButtonItem.Style = .plain,
            accessibilityIdentifier: String? = nil,
            action: @escaping @MainActor () -> Void
        ) -> NavigationBarButton {
            NavigationBarButton(
                content: .button(
                    title: title,
                    image: image,
                    style: style
                ),
                action: action,
                accessibilityIdentifier: accessibilityIdentifier
            )
        }

        /// A bar button that presents a UIMenu (e.g. an ellipsis icon with menu items).
        /// Uses `UIDeferredMenuElement.uncached` so `menuProvider` is called each time the menu appears,
        /// allowing the view model to track analytics or dynamically build menu items.
        public static func menu(
            image: UIImage? = UIImage(systemName: "ellipsis.circle"),
            accessibilityIdentifier: String? = nil,
            menuProvider: @escaping @MainActor (@escaping ([UIMenuElement]) -> Void) -> Void
        ) -> NavigationBarButton {
            NavigationBarButton(
                content: .menu(
                    image: image,
                    menuProvider: menuProvider
                ),
                action: nil,
                accessibilityIdentifier: accessibilityIdentifier
            )
        }
    }
}

// MARK: - Content

extension DesignSystem.NavigationBarButton {
    public enum Content {
        case button(title: String?, image: UIImage?, style: UIBarButtonItem.Style)
        case menu(image: UIImage?, menuProvider: @MainActor (@escaping ([UIMenuElement]) -> Void) -> Void)
    }
}

// MARK: - Menu Item

extension DesignSystem {
    /// A declarative description of a single menu item within a `NavigationBarButton.menu`.
    @MainActor
    public struct NavigationBarMenuItem {
        public let title: String
        public let image: UIImage?
        public let attributes: UIMenuElement.Attributes
        public let action: @MainActor () -> Void

        public init(
            title: String,
            image: UIImage? = nil,
            isDestructive: Bool = false,
            action: @escaping @MainActor () -> Void
        ) {
            self.title = title
            self.image = image
            self.attributes = isDestructive ? .destructive : []
            self.action = action
        }

        /// Converts this item to a `UIAction` for use within a `UIMenu`.
        public func toUIAction() -> UIAction {
            UIAction(
                title: title,
                image: image,
                attributes: attributes,
                handler: { _ in action() }
            )
        }
    }
}
