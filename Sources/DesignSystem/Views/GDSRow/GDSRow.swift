import UIKit

public final class GDSRow: UIView, ContentView {
    let viewModel: GDSRowViewModel
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public init(viewModel: GDSRowViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        
        if let image = viewModel.image {
            imageView.image = UIImage(named: image)
        } else {
            imageView.isHidden = true
        }
        
        titleLabel.text = viewModel.title
        
        if let subtitle = viewModel.subtitle {
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }
        
        detailLabel.text = viewModel.detail
        
        if let icon = viewModel.icon {
            iconView.image = UIImage(systemName: icon)
        } else {
            iconView.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        layer.cornerRadius = 8
        clipsToBounds = true

        addSubview(imageView)
        addSubview(verticalStack)
        addSubview(detailLabel)
        addSubview(iconView)
        
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(subtitleLabel)
        
        let imageRatio = (imageView.image?.size.width ?? 1) / (imageView.image?.size.height ?? 1)
        
        NSLayoutConstraint.activate([
            // ImageView constraints
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalToConstant: 42),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: imageRatio),
            
            // Vertical stack constraints
            verticalStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            verticalStack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8),
            verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            verticalStack.trailingAnchor.constraint(lessThanOrEqualTo: detailLabel.leadingAnchor, constant: -8),
            verticalStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Detail label constraints
            detailLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 50),
            detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // IconView constraints
            iconView.leadingAnchor.constraint(equalTo: detailLabel.trailingAnchor, constant: 8),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
