import UIKit

public final class GDSList: UIView, ContentView {
    public let viewModel: GDSListViewModel
    
    private lazy var containerStackView: UIStackView = {
        let result = UIStackView(
            views: [
                titleLabel,
                listStackView
            ],
            spacing: DesignSystem.Spacing.GDSList.betweenRows,
            distribution: .fillProportionally
        )
        return result
    }()
    
    private lazy var titleLabel: UILabel = {
        let result = UILabel()
        if let title = viewModel.title {
            result.text = title.value
            result.font = viewModel.titleConfig?.font
            result.adjustsFontForContentSizeCategory = true
            result.textAlignment = .left
            result.numberOfLines = 0
            if let isHeader = viewModel.titleConfig?.isHeader,
               isHeader {
                result.accessibilityTraits = [.header]
            }
        } else {
            result.isHidden = true
        }
        result.accessibilityIdentifier = "\(viewModel.style.identifierPrefix)-list-title-label"
        return result
    }()
    
    private lazy var listStackView: UIStackView = {
        let result = UIStackView(
            views: makeRows(),
            spacing: DesignSystem.Spacing.small,
            distribution: .fillProportionally
        )
        result.isLayoutMarginsRelativeArrangement = true
        result.layoutMargins.left = DesignSystem.Spacing.GDSList.leadingMargin
        return result
    }()
    
    private var maxNumberWidth: CGFloat {
        viewModel.items.indices
            .map { index in
                let number = UILabel()
                number.text = "\(index + 1)."
                number.font = DesignSystem.Font.Base.body
                number.adjustsFontForContentSizeCategory = true
                return number
            }
            .map(\UILabel.intrinsicContentSize.width)
            .max() ?? 0
    }
    
    public required init(viewModel: GDSListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    private func reloadListView() {
        self.listStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        let newRows = self.makeRows()
        
        newRows.forEach {
            self.listStackView.addArrangedSubview($0)
        }
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        addSubview(containerStackView)
        containerStackView.bindToSuperviewEdges()
    }
    
    private func makeRows() -> [UIStackView] {
        switch viewModel.style {
        case .numbered:
            createNumberedlist()
        case .bulleted:
            createBulletedList()
        }
    }
    
    private func contentLabels(for item: GDSLocalisedString) -> UILabel {
        let label = UILabel()
        label.font = DesignSystem.Font.Base.body
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byWordWrapping
        
        if let attributedString = item.attributedValue {
            label.attributedText = attributedString
        } else {
            label.text = item.value
        }
        return label
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        reloadListView()
    }
    
    private func createNumberedlist() -> [UIStackView] {
        return viewModel.items.enumerated()
            .map { index, item in
                let indexIncremented = index + 1
                let numberLabel = UILabel()
                numberLabel.text = "\(indexIncremented)."
                numberLabel.font = DesignSystem.Font.Base.body
                numberLabel.textAlignment = .right
                numberLabel.adjustsFontForContentSizeCategory = true
                numberLabel.widthAnchor.constraint(equalToConstant: maxNumberWidth).isActive = true
                
                let textLabel = contentLabels(for: item)
                let row = UIStackView(
                    views: [numberLabel, textLabel],
                    axis: .horizontal,
                    spacing: DesignSystem.Spacing.GDSList.beforeLabel,
                    alignment: .top,
                    distribution: .fill
                )
                
                row.isAccessibilityElement = true
                let summaryLabel = GDSLocalisedString(
                    stringKey: "Numbered List",
                    String(viewModel.items.count),
                    bundle: .module
                )
                let number = NSLocalizedString(
                    key: String(indexIncremented),
                    bundle: .module
                )
                let listLabel = "\(number), \(item.value)"
                row.accessibilityLabel = indexIncremented == 1 ? "\(summaryLabel.value) \(listLabel)" : listLabel
                row.accessibilityIdentifier = "numbered-list-row-stack-view-\(indexIncremented)"
                return row
            }
    }
    
    private func createBulletedList() -> [UIStackView] {
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        let scaledSize = fontMetrics.scaledValue(for: 6)
        let bulletSymbol = UIImage(systemName: "circle.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: scaledSize, weight: .semibold)
        )
        
        return viewModel.items.enumerated().map { index, item in
            let bullet = UIImageView(image: bulletSymbol)
            bullet.tintColor = .label
            bullet.setContentHuggingPriority(.required, for: .horizontal)
            bullet.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            
            let textLabel = contentLabels(for: item)
            let row = UIStackView(
                views: [bullet, textLabel],
                axis: .horizontal,
                spacing: DesignSystem.Spacing.GDSList.beforeLabel,
                alignment: .center,
                distribution: .fill
            )
            
            row.isAccessibilityElement = true
            let summaryLabel = GDSLocalisedString(
                stringKey: "Bulleted List",
                String(viewModel.items.count),
                bundle: .module
            )
            let number = NSLocalizedString(
                key: String(index + 1),
                bundle: .module
            )
            let listLabel = "\(number), \(item.value)"
            row.accessibilityLabel = index == 0
            ? "\(summaryLabel) \(listLabel)"
            : listLabel
            
            row.accessibilityIdentifier = "bulleted-list-row-stack-view-\(index + 1)"
            
            return row
        }
    }
}
