import UIKit

// swiftlint:disable:next type_body_length
public final class GDSRow: UIControl, ContentView {
    let viewModel: GDSRowViewModel
    
    private var enableInteration: Bool {
        viewModel.action == nil
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = false
        imageView.isUserInteractionEnabled = enableInteration
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: viewModel.title,
            font: viewModel.titleFont,
            colour: viewModel.titleColour
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.isUserInteractionEnabled = enableInteration
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(
            font: viewModel.subtitleFont,
            colour: viewModel.subtitleColour
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.isUserInteractionEnabled = enableInteration
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel(
            font: viewModel.detailFont,
            colour: viewModel.detailColour,
            alignment: .right
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.isUserInteractionEnabled = enableInteration
        return label
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        let colour = viewModel.iconStyle?.colour ?? DesignSystem.Color.GDSRow.icon
        imageView.tintColor = colour
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.isUserInteractionEnabled = enableInteration
        return imageView
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = enableInteration
        return stack
    }()
    
    private lazy var divider: UIView = {
        let divider = GDSDividerView(
            viewModel: GDSDividerViewModel(
                colour: DesignSystem.Color.Dividers.default
            )
        )
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.isUserInteractionEnabled = enableInteration
        return divider
    }()
    
    public init(viewModel: GDSRowViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        setupAccessibility()
        setupActionIfNeeded()
        
        self.isEnabled = viewModel.action != nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func setupView() {
        clipsToBounds = true
        
        if let image = viewModel.image {
            imageView.image = image
            addSubview(imageView)
        }
        
        addSubview(verticalStack)
        
        if let detail = viewModel.detail {
            detailLabel.text = detail
            addSubview(detailLabel)
        }
        
        if let icon = viewModel.iconStyle {
            let iconFont = icon.font ?? DesignSystem.Font.Base.bodySemiBold
            let config = UIImage.SymbolConfiguration(font: iconFont)
            iconView.image = UIImage(systemName: icon.icon, withConfiguration: config)
            addSubview(iconView)
        }
        
        verticalStack.addArrangedSubview(titleLabel)
        
        if let subtitle = viewModel.subtitle {
            subtitleLabel.text = subtitle
            verticalStack.addArrangedSubview(subtitleLabel)
        }
        
        
    }
    
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        let hasImage = viewModel.image != nil
        let hasDetail = viewModel.detail != nil
        let hasIcon = viewModel.iconStyle != nil
        
        let verticalPadding = viewModel.verticalPaddingValue
        let minRowHeight = viewModel.type.minRowHeight
        
        let leadingView: UIView = {
            hasImage ? imageView : verticalStack
        }()
        
        let trailingView: UIView

        if hasIcon {
            trailingView = iconView
        } else {
            trailingView = hasDetail ? detailLabel : verticalStack
        }
        
        if hasImage {
            let imageRatio = (imageView.image?.size.height ?? 1) / (imageView.image?.size.width ?? 1)
            
            NSLayoutConstraint.activate(
                [
                    imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    imageView.topAnchor.constraint(
                        greaterThanOrEqualTo: topAnchor,
                        constant: verticalPadding
                    ),
                    imageView.bottomAnchor.constraint(
                        lessThanOrEqualTo: bottomAnchor,
                        constant: -verticalPadding
                    ),
                    imageView.widthAnchor.constraint(equalToConstant: DesignSystem.Size.GDSRow.imageWidth),
                    imageView.heightAnchor.constraint(
                        equalTo: imageView.widthAnchor,
                        multiplier: imageRatio
                    ),
                    verticalStack.leadingAnchor.constraint(
                        equalTo: imageView.trailingAnchor,
                        constant: DesignSystem.Spacing.GDSRow.imageToTitleSpacing
                    )
                ]
            )
        }
        
        if hasDetail {
            NSLayoutConstraint.activate(
                [
                    verticalStack.trailingAnchor.constraint(
                        equalTo: detailLabel.leadingAnchor,
                        constant: -DesignSystem.Spacing.small
                    ),
                    detailLabel.widthAnchor.constraint(
                        lessThanOrEqualToConstant: DesignSystem.Size.GDSRow.detailWidth
                    ),
                    detailLabel.centerYAnchor.constraint(
                        equalTo: centerYAnchor
                    ),
                    heightAnchor.constraint(
                        greaterThanOrEqualTo: detailLabel.heightAnchor,
                        constant: DesignSystem.Spacing.small
                    )
                ]
            )
        }
        
        if hasIcon {
            NSLayoutConstraint.activate(
                [
                    iconView.leadingAnchor.constraint(
                        equalTo: hasDetail ?
                        detailLabel.trailingAnchor
                        : verticalStack.trailingAnchor,
                        constant: DesignSystem.Spacing.default
                    ),
                    iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    heightAnchor.constraint(
                        greaterThanOrEqualTo: iconView.heightAnchor,
                        constant: DesignSystem.Spacing.small
                    )
                ]
            )
        }
        
        NSLayoutConstraint.activate(
            [
                heightAnchor.constraint(greaterThanOrEqualToConstant: minRowHeight),
                leadingView.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: DesignSystem.Spacing.default
                ),
                
                // Vertical stack constraints
                verticalStack.topAnchor.constraint(
                    greaterThanOrEqualTo: topAnchor,
                    constant: verticalPadding
                ),
                verticalStack.bottomAnchor.constraint(
                    lessThanOrEqualTo: bottomAnchor,
                    constant: -verticalPadding
                ),
                verticalStack.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                trailingView.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -DesignSystem.Spacing.default
                )
            ]
        )
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = viewModel.accessibilityTraits
        accessibilityHint = viewModel.iconStyle?.accessibilityHint
        
        let labels = [
            viewModel.imageAltText,
            titleLabel.text,
            viewModel.subtitle,
            viewModel.detail,
            viewModel.iconStyle?.accessibilityHint
        ]
            .compactMap { $0 }
        
        accessibilityLabel = labels.joined(separator: ", ")
    }
    
    private func setupActionIfNeeded() {
        if viewModel.action != nil {
            accessibilityTraits.insert(.button)
        }
        
        switch viewModel.action {
        case .action(let closure):
            let action = UIAction { _ in
                closure()
            }
            addAction(action, for: .touchUpInside)
        case .asyncAction(let closure):
            let action = UIAction { _ in
                Task { @MainActor in
                    await closure()
                }
            }
            addAction(action, for: .touchUpInside)
        case .none:
            break
        }
    }
    
    public func addDivider() {
        addSubview(divider)
        NSLayoutConstraint.activate(
            [
                divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                divider.trailingAnchor.constraint(equalTo: trailingAnchor),
                divider.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
}
