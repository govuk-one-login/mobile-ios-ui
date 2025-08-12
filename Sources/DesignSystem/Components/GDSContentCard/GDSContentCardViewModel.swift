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
        items.forEach { item in
            let stack = UIStackView(
                views: item.uiView,
                alignment: .fill,
                distribution: .fill
            )
            if let dismissAction {
                if items.first is ContentImageViewModel {
                    if item is ContentImageViewModel {
                        addDismissButton(type: .image, stackView: stack, action: dismissAction)
                    }
                } else if item is ContentTitleViewModel {
                    addDismissButton(type: .title, stackView: stack, action: dismissAction)
                }
            }
            additionalStackViewConfiguration(stack, contentItem: item)
            stackView.addArrangedSubview(stack)
        }
        if showShadow { addShadowToView(stackView) }
        return stackView
    }
}

extension GDSContentCardViewModel {
    private enum StackViewType {
        case image, title
    }
    
    @MainActor
    private func addDismissButton(
        type: StackViewType,
        stackView: UIStackView,
        action: ButtonAction
    ) {
        let dismissButton = GDSButtonViewModel(
            title: "",
            icon: "xmark",
            style: .secondary,
            buttonAction: action
        ).uiView
        
        switch type {
        case .image:
            stackView.addSubview(dismissButton)
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dismissButton.topAnchor.constraint(equalTo: stackView.topAnchor),
                dismissButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            ])
        case .title:
            stackView.spacing = 0
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
            stackView.addArrangedSubview(dismissButton)
        }
    }
    
    @MainActor
    func additionalStackViewConfiguration(_ stackView: UIStackView, contentItem: ContentItem) {
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: contentItem.verticalPadding?.topPadding ?? .zero,
            leading: contentItem.horizontalPadding?.leadingPadding ?? DesignSystem.Spacing.default,
            bottom: contentItem.verticalPadding?.bottomPadding ?? .zero,
            trailing: contentItem.horizontalPadding?.trailingPadding ?? DesignSystem.Spacing.default
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @MainActor
    private func addShadowToView(_ stackView: UIStackView) {
        stackView.layer.shadowRadius = 10
        stackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.masksToBounds = false
    }
}
