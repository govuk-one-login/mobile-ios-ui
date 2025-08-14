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
        GDSContentCardView(viewModel: self)
    }
}

extension UIView {
    var allNestedSubviews: [UIView] {
        self.subviews.flatMap { [$0] + $0.allNestedSubviews }
    }
}

@MainActor
class GDSContentCardView: UIView {
    private enum StackViewType {
        case image, title
    }
    
    let viewModel: GDSContentCardViewModel
    
    var dismissButton: UIButton = UIButton()
    var buttonWidthConstraint: NSLayoutConstraint?
    
    private var contentSize: UIContentSizeCategory {
        didSet {
            if let buttonWidthConstraint {
                dismissButton.removeConstraint(buttonWidthConstraint)
            }
            let adjustment = SizeAdjustment.size(for: contentSize)
            buttonWidthConstraint = dismissButton.widthAnchor.constraint(
                equalToConstant: (
                    20 * adjustment
                ) + DesignSystem.Spacing.xLarge // this should really be set from the button horizontal content insets - both == 32 currently so this works
            )
            buttonWidthConstraint?.isActive = true
            layoutIfNeeded()
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            spacing: 0,
            alignment: .fill,
            distribution: .fill
        )
        stackView.layer.cornerRadius = 12 // probably should use a design system constant
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBackground
        viewModel.items.forEach { item in
            let stack = UIStackView(
                views: item.uiView,
                alignment: .fill,
                distribution: .fill
            )
            if let dismissAction = viewModel.dismissAction {
                if viewModel.items.first is ContentImageViewModel {
                    if item is ContentImageViewModel {
                        addDismissButton(
                            type: .image,
                            stackView: stack,
                            action: dismissAction
                        )
                    }
                } else if item is ContentTitleViewModel {
                    addDismissButton(
                        type: .title,
                        stackView: stack,
                        action: dismissAction
                    )
                }
            }
            additionalStackViewConfiguration(stack, contentItem: item)
            stackView.addArrangedSubview(stack)
            stackView.layoutSubviews()
        }
        
        if viewModel.showShadow {
            addShadowToView(stackView)
        }
        return stackView
    }()
    
    init(viewModel: GDSContentCardViewModel) {
        self.viewModel = viewModel
        self.contentSize = UIApplication.shared.preferredContentSizeCategory
        
        super.init(frame: .zero)
        addStackToView()
        
        NotificationCenter.default.addObserver(
            forName: UIContentSizeCategory.didChangeNotification,
            object: nil,
            queue: nil
        ) { _ in
            Task { @MainActor in
                self.contentSize = UIApplication.shared.preferredContentSizeCategory
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addStackToView() {
        self.addSubview(stackView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    @MainActor
    private func addDismissButton(
        type: StackViewType,
        stackView: UIStackView,
        action: ButtonAction
    ) {
        let dismissButtonViewModel = GDSButtonViewModel(
            title: "",
            icon: "xmark",
            style: .secondary.adjusting(
                alignment: .trailing
            ),
            buttonAction: action
        )
        
        dismissButton = dismissButtonViewModel.uiView as? UIButton ?? UIButton()
        
        dismissButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dismissButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        dismissButton.titleLabel?.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dismissButton.titleLabel?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        let adjustment = SizeAdjustment.size(for: contentSize)
        
        buttonWidthConstraint =  dismissButton.widthAnchor.constraint(
            equalToConstant: (
                20 * adjustment
            ) + DesignSystem.Spacing.xLarge // this should really be set from the button horizontal content insets - both == 32 currently so this works
        )
        buttonWidthConstraint?.isActive = true

        switch type {
        case .image:
            stackView.addSubview(dismissButton)
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dismissButton.topAnchor.constraint(equalTo: stackView.topAnchor),
                dismissButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            ])
        case .title:
            stackView.spacing = .zero
            stackView.axis = .horizontal
            stackView.alignment = .top
            stackView.distribution = .fill
            stackView.addArrangedSubview(dismissButton)
        }
        dump(dismissButton.intrinsicContentSize)
        stackView.layoutSubviews()
        dump(dismissButton.intrinsicContentSize)
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
