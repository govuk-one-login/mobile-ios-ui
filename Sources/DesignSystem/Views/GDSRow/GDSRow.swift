import UIKit

public final class GDSRow: UIView, ContentView {
    let viewModel: GDSRowViewModel
    
    private lazy var textStackView: UIStackView = {
        let result = UIStackView(
            views: [titleLabel, subtitleLabel],
            axis: .vertical,
            spacing: 0,
            distribution: .fill
        )
        result.isLayoutMarginsRelativeArrangement = true
        result.translatesAutoresizingMaskIntoConstraints = false
        result.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return result
    }()
    
    private lazy var titleLabel: UILabel = {
        let result = UILabel()
        result.text = viewModel.title
        result.font = DesignSystem.Font.Base.body
        result.adjustsFontForContentSizeCategory = true
        result.textAlignment = .left
        result.numberOfLines = 0
        
        return result
    }()
    
    // optional
    private lazy var subtitleLabel: UILabel = {
        let result = UILabel()
        if let subtitle = viewModel.subtitle {
            result.text = subtitle
            result.font = DesignSystem.Font.Base.footnote
            result.adjustsFontForContentSizeCategory = true
            result.textAlignment = .left
            result.numberOfLines = 0
        } else {
            result.isHidden = true
        }
        return result
    }()
    
    private lazy var detailLabel: UILabel = {
        let result = UILabel()

        if let detail = viewModel.detail {
            result.text = detail
            result.font = DesignSystem.Font.Base.body
            result.adjustsFontForContentSizeCategory = true
            result.textAlignment = .left
            result.numberOfLines = 0
            result.translatesAutoresizingMaskIntoConstraints = false
            result.widthAnchor.constraint(lessThanOrEqualToConstant: 45).isActive = true
        } else {
            result.isHidden = true
        }
        return result
    }()
    
    // optional
    private lazy var leadingImageView: UIImageView = {
        let result = UIImageView()
        if let image = viewModel.image {
            result.image = UIImage(named: image)
            result.contentMode = .scaleAspectFit
            result.clipsToBounds = true
            result.translatesAutoresizingMaskIntoConstraints = false
            result.widthAnchor.constraint(lessThanOrEqualToConstant: 42).isActive = true
            result.heightAnchor.constraint(lessThanOrEqualToConstant: 42).isActive = true
        } else {
            result.isHidden = true
        }
        return result
    }()
    
    // optional
    private lazy var trailingIconView: UIImageView = {
        let result = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(font: DesignSystem.Font.Base.bodySemiBold)
        
        if let icon = viewModel.icon {
            result.image = UIImage(systemName: icon, withConfiguration: symbolConfig)
            result.tintColor = .tertiaryLabel
            result.contentMode = .scaleAspectFit
            result.translatesAutoresizingMaskIntoConstraints = false
            result.setContentHuggingPriority(.defaultLow, for: .horizontal)
            result.setContentCompressionResistancePriority(.required, for: .horizontal)
        } else {
            result.isHidden = true
        }
        return result
    }()
    
    
    public init(viewModel: GDSRowViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.layer.cornerRadius = 10
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .secondarySystemBackground
        
        let verticalPadding: CGFloat = viewModel.verticalPaddingValue
        let minRowHeight: CGFloat = viewModel.type.minRowHeight
        
        self.addSubview(leadingImageView)
        self.addSubview(textStackView)
        self.addSubview(detailLabel)
        self.addSubview(trailingIconView)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: minRowHeight),
            
            leadingImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leadingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            textStackView.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: 12),
            textStackView.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),

            detailLabel.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: 8),
            detailLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),
            
            trailingIconView.leadingAnchor.constraint(equalTo: detailLabel.trailingAnchor, constant: 16),
            trailingIconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trailingIconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
