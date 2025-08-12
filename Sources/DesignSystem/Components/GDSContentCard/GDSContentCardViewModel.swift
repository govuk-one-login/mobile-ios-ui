import UIKit

public struct GDSContentCardViewModel {
    public let items: [ContentItem]
    public let showShadow: Bool
    public let dismissAction: (() -> Void)?
    
    public init(
        items: [ContentItem],
        showShadow: Bool,
        dismissAction: (() -> Void)? = nil
    ) {
        self.items = items
        self.showShadow = showShadow
        self.dismissAction = dismissAction
    }
}

extension GDSContentCardViewModel: ContentItem {
    public var uiView: UIView {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 12
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBackground
        items.forEach {
            let stack = UIStackView(
                views: [ $0.uiView ],
                distribution: .fill
            )
            if let dismissAction {
                let dismissButton = GDSButtonViewModel(
                    title: "",
                    icon: "xmark",
                    style: .secondary,
                    buttonAction: .action(dismissAction)
                ).uiView
                if items.first is ContentImageViewModel {
                    if $0 is ContentImageViewModel {
                        stack.addSubview(dismissButton)
                        dismissButton.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            dismissButton.topAnchor.constraint(equalTo: stack.topAnchor),
                            dismissButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor)
                        ])
                    }
                } else if $0 is ContentTitleViewModel {
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
}
