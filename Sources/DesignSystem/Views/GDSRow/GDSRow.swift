import UIKit

public final class GDSRow: UIView, ContentView {
    let viewModel: GDSRowViewModel

    public init(viewModel: GDSRowViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.layer.cornerRadius = 10
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .lightGray
//        self.addSubview(leadingImageView)
        self.addSubview(textStackView)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textStackView.topAnchor.constraint(equalTo: topAnchor),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // use self
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var textStackView: UIStackView = {
        let result = UIStackView(
            views: [titleLabel, subtitleLabel],
            axis: .vertical,
            spacing: 0,
            distribution: .fillProportionally
        )
        result.isLayoutMarginsRelativeArrangement = true
        return result
    }()
    
    private lazy var titleLabel: UILabel = {
        let result = UILabel()
        result.text = "HM Armed Forces Veteran Card"
        result.font = DesignSystem.Font.Base.body
        result.adjustsFontForContentSizeCategory = true
        result.textAlignment = .left
        result.numberOfLines = 0
        
        return result
    }()
    
    // optional
    private lazy var subtitleLabel: UILabel = {
        let result = UILabel()
        result.text = "Inactive since 30 October 2025"
        result.font = DesignSystem.Font.Base.footnote
        result.adjustsFontForContentSizeCategory = true
        result.textAlignment = .left
        result.numberOfLines = 0
        
        return result
    }()
    
    private lazy var detailLabel: UILabel = {
        let result = UILabel()
        result.text = "Detail"
        result.font = DesignSystem.Font.Base.body
        result.adjustsFontForContentSizeCategory = true
        result.textAlignment = .right
        result.numberOfLines = 0
        result.widthAnchor.constraint(lessThanOrEqualToConstant: 42).isActive = true
        result.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        
        return result
    }()
    
    // optional
    private lazy var leadingImageView: UIImageView = {
        let result = UIImageView()
        result.image = UIImage(named: "badge")
        result.contentMode = .scaleAspectFit
        result.clipsToBounds = true
        result.translatesAutoresizingMaskIntoConstraints = false
        result.widthAnchor.constraint(lessThanOrEqualToConstant: 42).isActive = true
        return result
    }()
    
}
