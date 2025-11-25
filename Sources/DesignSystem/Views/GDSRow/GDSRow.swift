import UIKit

public final class GDSRow: UIView, ContentView {
    let viewModel: GDSRowViewModel
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.title
        label.font = DesignSystem.Font.Base.body
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Font.Base.footnote
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Font.Base.body
        label.textColor = .tertiaryLabel
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .tertiaryLabel
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
        
        if let icon = viewModel.icon {
            let config = UIImage.SymbolConfiguration(font: DesignSystem.Font.Base.bodySemiBold)
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
            let imageRatio = (imageView.image?.size.width ?? 1) / (imageView.image?.size.height ?? 1)
            
            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: verticalPadding),
                imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -verticalPadding),
                imageView.widthAnchor.constraint(equalToConstant: 42),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: imageRatio),
                verticalStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12)
            ])
        }
        
        if hasDetail {
            NSLayoutConstraint.activate([
                verticalStack.trailingAnchor.constraint(lessThanOrEqualTo: detailLabel.leadingAnchor),
                detailLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 50),
                detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
            if hasIcon {
                NSLayoutConstraint.activate([
                    iconView.leadingAnchor.constraint(equalTo: detailLabel.trailingAnchor, constant: 16),
                    iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
            }
        } else if hasIcon {
            NSLayoutConstraint.activate([
                iconView.leadingAnchor.constraint(equalTo: verticalStack.trailingAnchor),
                iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: minRowHeight),
            leadingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // Vertical stack constraints
            verticalStack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: verticalPadding),
            verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -verticalPadding),
            verticalStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            // Divider constraints
            divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            trailingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    public func removeDivider() {
            divider.removeFromSuperview()
        }
}
