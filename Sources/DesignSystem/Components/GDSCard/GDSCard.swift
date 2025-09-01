import UIKit

public final class GDSCard: UIView, ContentView {
    let viewModel: GDSCardViewModel
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            spacing: 0,
            alignment: .fill,
            distribution: .fill
        )
        stackView.backgroundColor = viewModel.backgroundColour
        stackView.layer.cornerRadius = DesignSystem.CornerRadius.card
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.contentItems.forEach { item in
            let stack = UIStackView(
                views: item.createUIView(),
                alignment: .fill,
                distribution: .fill
            )
            if let dismissAction = viewModel.dismissAction {
                if viewModel.contentItems.first is GDSCardImageViewModel {
                    if item is GDSCardImageViewModel {
                        addDismissButton(
                            type: .image,
                            stackView: stack,
                            action: dismissAction
                        )
                    }
                } else if item is GDSCardTitleViewModel {
                    addDismissButton(
                        type: .title,
                        stackView: stack,
                        action: dismissAction
                    )
                }
            }
            additionalStackViewConfiguration(stack, contentItem: item)
            stackView.addArrangedSubview(stack)
        }
        
        if viewModel.showShadow {
            addShadowToView(stackView)
        }
        
        return stackView
    }()
    
    public init(viewModel: GDSCardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        addStackToView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        stackView.layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: DesignSystem.CornerRadius.card
        ).cgPath
    }
    
    func addStackToView() {
        self.addSubview(stackView)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addDismissButton(
        type: StackViewType,
        stackView: UIStackView,
        action: ButtonAction
    ) {
        let dismissButton = GDSButtonViewModel(
            title: .init(),
            icon: .xMark,
            style: .dismiss,
            buttonAction: action
        ).createUIView()
        
        switch type {
        case .image:
            stackView.addSubview(dismissButton)
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dismissButton.topAnchor.constraint(equalTo: stackView.topAnchor),
                dismissButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            ])
        case .title:
            dismissButton.setContentCompressionResistancePriority(.required, for: .horizontal)
            dismissButton.setContentHuggingPriority(.required, for: .horizontal)
            stackView.spacing = .zero
            stackView.axis = .horizontal
            stackView.alignment = .top
            stackView.distribution = .fill
            stackView.addArrangedSubview(dismissButton)
        }
    }
    
    private func additionalStackViewConfiguration(
        _ stackView: UIStackView,
        contentItem: any ContentViewModel
    ) {
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: contentItem.verticalPadding?.topPadding ?? .zero,
            leading: contentItem.horizontalPadding?.leadingPadding ?? .zero,
            bottom: contentItem.verticalPadding?.bottomPadding ?? .zero,
            trailing: contentItem.horizontalPadding?.trailingPadding ?? .zero
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addShadowToView(_ stackView: UIStackView) {
        stackView.layer.shadowRadius = DesignSystem.CornerRadius.card
        stackView.layer.shadowOffset = CGSize(width: .zero, height: 4)
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.shadowColor = DesignSystem.Color.Base.blackAlpha.cgColor
        stackView.layer.masksToBounds = false
    }
}

private enum StackViewType {
    case image, title
}
