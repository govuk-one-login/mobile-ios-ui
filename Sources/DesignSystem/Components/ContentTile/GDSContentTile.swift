import UIKit

final public class GDSContentTile: UIView {
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(
            views: [
                imageView,
                bodyStackView,
                separatorStackView,
                buttonStackView
            ],
            spacing: 0,
            distribution: .fill
        )
        stackView.layer.cornerRadius = 12
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = viewModel.backgroundColour
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        if let viewModel = viewModel as? GDSContentTileViewModelWithImage {
            imageView.image = viewModel.image
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            imageView.isHidden = true
        }
        return imageView
    }()
    
    private lazy var bodyStackView: UIStackView = {
        let stackView = UIStackView(
            views: [
                captionLabel,
                titleLabel,
                bodyLabel
            ],
            spacing: DesignSystem.Spacing.small,
            distribution: .fill
        )
        stackView.directionalLayoutMargins = .bodyStack
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var captionLabel: UILabel = {
        let caption = UILabel()
        if let viewModel = viewModel as? GDSContentTileViewModelWithImage,
           let imageCaption = viewModel.caption {
            caption.text = imageCaption.value
            caption.font = DesignSystem.Font.Base.caption1
            caption.adjustsFontForContentSizeCategory = true
            caption.textAlignment = .left
            caption.numberOfLines = 0
        } else {
            caption.isHidden = true
        }
        caption.accessibilityIdentifier = "numbered-list-caption"
        return caption
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = viewModel.title.value
        title.font = viewModel.titleFont
        title.adjustsFontForContentSizeCategory = true
        title.textAlignment = .left
        title.numberOfLines = 0
        title.accessibilityIdentifier = "numbered-list-title"
        return title
    }()
    
    private lazy var bodyLabel: UILabel = {
        let body = UILabel()
        if let viewModel = viewModel as? GDSContentTileViewModelWithBody {
            body.text = viewModel.body.value
            body.font = DesignSystem.Font.Base.body
            body.adjustsFontForContentSizeCategory = true
            body.textAlignment = .left
            body.numberOfLines = 0
        } else {
            body.isHidden = true
        }
        body.accessibilityIdentifier = "numbered-list-body"
        return body
    }()
    
    private lazy var separatorStackView: UIStackView = {
        let stackView = UIStackView(
            views: [
                separatorView
            ],
            spacing: DesignSystem.Spacing.small,
            distribution: .fill
        )
        stackView.directionalLayoutMargins = .separator
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let separator = UIView()
        if viewModel.showSeparatorLine {
            separator.backgroundColor = .separator
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            separator.translatesAutoresizingMaskIntoConstraints = false
        } else {
            separator.isHidden = true
        }
        separator.accessibilityIdentifier = "numbered-list-separator"
        return separator
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(
            views: [
                secondaryButton,
                primaryButton
            ],
            spacing: DesignSystem.Spacing.small,
            distribution: .fill
        )
        stackView.directionalLayoutMargins = .buttonStack
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var secondaryButton: UIButton = {
        if let viewModel = viewModel as? GDSContentTileViewModelWithSecondaryButton {
            let secondaryButton = GDSButton(viewModel: viewModel.secondaryButtonViewModel)
            secondaryButton.contentHorizontalAlignment = .left
            secondaryButton.isUserInteractionEnabled = true
            secondaryButton.accessibilityIdentifier = "content-secondary-button"
            return secondaryButton
        } else {
            let secondaryButton = UIButton()
            secondaryButton.isHidden = true
            return secondaryButton
        }
    }()
    
    lazy var primaryButton: UIButton = {
        if let viewModel = viewModel as? GDSContentTileViewModelWithPrimaryButton {
            let secondaryButton = GDSButton(viewModel: viewModel.primaryButtonViewModel)
            secondaryButton.contentHorizontalAlignment = .left
            secondaryButton.isUserInteractionEnabled = true
            secondaryButton.accessibilityIdentifier = "content-secondary-button"
            return secondaryButton
        } else {
            let secondaryButton = UIButton()
            secondaryButton.isHidden = true
            return secondaryButton
        }
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        if let viewModel = viewModel as? GDSContentTileViewModelWithDismissButton {
            configureDismissButton(button)
            button.tintColor = traitCollection.userInterfaceStyle == .dark ?
            DesignSystem.Color.Base.green1
            : DesignSystem.Color.Base.green2
            button.addAction(
                UIAction { [unowned self] _ in
                    viewModel.closeButtonAction()
                },
                for: .touchUpInside
            )
        } else {
            button.isHidden = true
        }
        button.accessibilityIdentifier = "close-button"
        return button
    }()
    
    public let viewModel: GDSContentTileViewModel
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(viewModel: GDSContentTileViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setUp()
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        viewModel is GDSContentTileViewModelWithDismissButton ? configureDismissButton(dismissButton) : nil
    }
    
    private func setUp() {
        addSubview(containerStackView)
        containerStackView.bindToSuperviewEdges()
        viewModel is GDSContentTileViewModelWithDismissButton ? addDismissButton() : ()
        viewModel.applyShadow ? applyShadow() : ()
    }
    
    private func applyShadow() {
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }
    
    private func addDismissButton() {
        addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(
                equalTo: containerStackView.topAnchor
            ),
            dismissButton.trailingAnchor.constraint(
                equalTo: containerStackView.trailingAnchor
            )]
        )
        if !(viewModel is GDSContentTileViewModelWithImage) {
            titleLabel.trailingAnchor
                .constraint(
                    equalTo: dismissButton.leadingAnchor
                ).isActive = true
            bodyLabel.trailingAnchor
                .constraint(
                    equalTo: containerStackView.trailingAnchor,
                    constant: -DesignSystem.Spacing.default
                )
                .isActive = true
        }
    }
    
    private func configureDismissButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont.preferredFont(forTextStyle: .footnote)
        let config = UIImage.SymbolConfiguration(pointSize: font.pointSize, weight: .regular)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.configuration = .closeButton
        
        button.constraints.forEach { $0.isActive = false }
        
        button.widthAnchor.constraint(equalToConstant: font.pointSize + 32).isActive = true
        button.heightAnchor.constraint(equalToConstant: font.pointSize + 24).isActive = true
    }
}
