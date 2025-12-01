import UIKit

public final class GDSRow: UIView, ContentView {
    let viewModel: GDSRowViewModel
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = false
        
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
        return label
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = viewModel.iconColour
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        return imageView
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var divider: UIView = {
        let divider = GDSDividerView(
            viewModel: GDSDividerViewModel(
                height: 0.5,
                colour: .separator
            )
        )
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    public init(viewModel: GDSRowViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        setupAccessibility()
        setupActionIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func setupView() {
        clipsToBounds = true
        
        if let image = viewModel.image {
            imageView.image = UIImage(named: image)
            addSubview(imageView)
        }
        
        addSubview(verticalStack)
        
        if let detail = viewModel.detail {
            detailLabel.text = detail
            addSubview(detailLabel)
        }
        
        if let icon = viewModel.icon, let iconFont = viewModel.iconFont {
            let config = UIImage.SymbolConfiguration(font: iconFont)
            iconView.image = UIImage(systemName: icon, withConfiguration: config)?
                .withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
            addSubview(iconView)
        }
        
        verticalStack.addArrangedSubview(titleLabel)
        
        if let subtitle = viewModel.subtitle {
            subtitleLabel.text = subtitle
            verticalStack.addArrangedSubview(subtitleLabel)
        }
        
        addSubview(divider)
    }
    
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        let hasImage = viewModel.image != nil
        let hasDetail = viewModel.detail != nil
        let hasIcon = viewModel.icon != nil
        
        let verticalPadding = viewModel.verticalPaddingValue
        let minRowHeight = viewModel.type.minRowHeight
        
        let leadingView: UIView = {
            hasImage ? imageView : verticalStack
        }()
        
        let trailingView: UIView = {
            hasIcon ? iconView : (hasDetail ? detailLabel : verticalStack)
        }()
        
        if hasImage {
            let imageRatio = (imageView.image?.size.height ?? 1) / (imageView.image?.size.width ?? 1)
            
            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: verticalPadding),
                imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -verticalPadding),
                imageView.widthAnchor.constraint(equalToConstant: DesignSystem.Size.GDSRow.imageWidth),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: imageRatio),
                verticalStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: DesignSystem.Spacing.GDSRow.imageToTitleSpacing)
            ])
        }
        
        if hasDetail {
            NSLayoutConstraint.activate([
                verticalStack.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor),
                detailLabel.widthAnchor.constraint(lessThanOrEqualToConstant: DesignSystem.Size.GDSRow.detailWidth),
                detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                heightAnchor.constraint(greaterThanOrEqualTo: detailLabel.heightAnchor, constant: DesignSystem.Spacing.small)
            ])
            
            if hasIcon {
                NSLayoutConstraint.activate([
                    iconView.leadingAnchor.constraint(equalTo: detailLabel.trailingAnchor, constant: DesignSystem.Spacing.default),
                    iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    heightAnchor.constraint(greaterThanOrEqualTo: iconView.heightAnchor, constant: DesignSystem.Spacing.small)
                ])
            }
        } else if hasIcon {
            NSLayoutConstraint.activate([
                iconView.leadingAnchor.constraint(equalTo: verticalStack.trailingAnchor),
                iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
                heightAnchor.constraint(greaterThanOrEqualTo: iconView.heightAnchor, constant: DesignSystem.Spacing.small)
            ])
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: minRowHeight),
            leadingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DesignSystem.Spacing.default),
            
            // Vertical stack constraints
            verticalStack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: verticalPadding),
            verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -verticalPadding),
            verticalStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            // Divider constraints
            divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            trailingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DesignSystem.Spacing.default)
        ])
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = viewModel.accessibilityTraits
        accessibilityHint = viewModel.accessibilityHint
        
        let labels = [
            viewModel.imageAltText,
            titleLabel.text,
            viewModel.subtitle,
            viewModel.detail,
            viewModel.iconAltText
        ]
        .compactMap { $0 != nil ? $0 : nil }
        
        accessibilityLabel = labels.joined(separator: ", ")
    }
    
    private func setupActionIfNeeded() {
        if viewModel.action != nil {
            isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
            self.addGestureRecognizer(tap)
        } else {
            accessibilityTraits.remove(.button)
        }
    }
    
    @MainActor
    @objc private func didTap() {
        Task {
            await viewModel.action?()
        }
    }
    
    public func removeDivider() {
            divider.removeFromSuperview()
        }
}
