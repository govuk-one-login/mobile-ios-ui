import UIKit

public final class GDSContentCardView: UIView {
    let viewModel: GDSContentCardViewModel

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            spacing: 0,
            alignment: .fill,
            distribution: .fill
        )
        stackView.layer.cornerRadius = 12
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
        }

        if viewModel.showShadow {
            addShadowToView(stackView)
        }
        
        return stackView
    }()

    init(viewModel: GDSContentCardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        addStackToView()
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

    private func addDismissButton(
        type: StackViewType,
        stackView: UIStackView,
        action: ButtonAction
    ) {
        let dismissButton = GDSButtonViewModel(
            title: .init(),
            icon: .xmark,
            style: .secondary.adjusting(
                alignment: .trailing,
                contentInsets: .dismissButton,
                backgroundColor: ColorForState(
                    normal: .clear,
                    focused: DesignSystem.Color.Base.yellow
                )
            ),
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
            stackView.spacing = .zero
            stackView.axis = .horizontal
            stackView.alignment = .top
            stackView.distribution = .fillProportionally
            stackView.addArrangedSubview(dismissButton)
        }
    }

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

    private func addShadowToView(_ stackView: UIStackView) {
        stackView.layer.shadowRadius = 10
        stackView.layer.shadowOffset = CGSize(width: .zero, height: 3)
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.shadowColor = DesignSystem.Color.Base.black1.cgColor
        stackView.layer.masksToBounds = false
    }
}

private enum StackViewType {
    case image, title
}
