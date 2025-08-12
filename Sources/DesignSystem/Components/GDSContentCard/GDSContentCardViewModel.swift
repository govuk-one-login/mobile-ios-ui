import UIKit

public struct GDSContentCardViewModel {
    public let items: [ContentItem]
    public let showShadow: Bool
    public let dismissAction: ButtonAction?
    
    public init(
        items: [ContentItem],
        showShadow: Bool,
        dismissAction: ButtonAction? = nil
    ) {
        self.items = items
        self.showShadow = showShadow
        self.dismissAction = dismissAction
    }
}

extension GDSContentCardViewModel: ContentItem {
    public var uiView: UIView {
        let stackView = UIStackView(
            spacing: 8,
            alignment: .fill,
            distribution: .fill
        )
        stackView.layer.cornerRadius = 12
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBackground
        items.forEach {
            let stack = UIStackView(
                views: $0.uiView,
                alignment: .fill,
                distribution: .fill
            )
            if let dismissAction {
                if items.first is ContentImageViewModel {
                    if $0 is ContentImageViewModel {
                        let dismissButton = createDismissButton(action: dismissAction)
                        stack.addSubview(dismissButton)
                        dismissButton.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            dismissButton.topAnchor.constraint(equalTo: stack.topAnchor),
                            dismissButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor)
                        ])
                    }
                } else if $0 is ContentTitleViewModel {
                    let dismissButton = createDismissButton(action: dismissAction)
                    stack.spacing = 0
                    stack.axis = .horizontal
                    stack.alignment = .center
                    stack.distribution = .fillProportionally
                    stack.addArrangedSubview(dismissButton)
                }
            }
            stack.isLayoutMarginsRelativeArrangement = true
            stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
                top: $0.verticalPadding?.topPadding ?? .zero,
                leading: $0.horizontalPadding?.leadingPadding ?? DesignSystem.Spacing.default,
                bottom: $0.verticalPadding?.bottomPadding ?? .zero,
                trailing: $0.horizontalPadding?.trailingPadding ?? DesignSystem.Spacing.default
            )
            stack.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(stack)
        }
        if showShadow {
            stackView.layer.shadowRadius = 10
            stackView.layer.shadowOffset = CGSize(width: 0, height: 3)
            stackView.layer.shadowOpacity = 0.1
            stackView.layer.shadowColor = UIColor.black.cgColor
            stackView.layer.masksToBounds = false
        }
        return stackView
    }
    
    @MainActor
    func createDismissButton(action: ButtonAction) -> UIView {
        GDSButtonViewModel(
            title: "",
            icon: "xmark",
            style: .secondary,
            buttonAction: action
        ).uiView
    }
}
