import UIKit

public final class GDSList: UIView, ContentView {
    public let viewModel: GDSListViewModel
    
    private lazy var titleLabel: UILabel = {
        let result = UILabel(colour: DesignSystem.Color.GDSList.title)
        if let title = viewModel.title {
            result.text = title.value
            result.font = viewModel.titleConfig?.font
            if let isHeader = viewModel.titleConfig?.isHeader,
               isHeader {
                result.accessibilityTraits = [.header]
            }
        } else {
            result.isHidden = true
        }
        result.accessibilityIdentifier = "\(viewModel.style.rawValue)-list-title-label"
        return result
    }()
    
    private lazy var listStackView: UIStackView = {
        let views = [titleLabel] + makeRows()
        let result = UIStackView(
            views: [],
            spacing: DesignSystem.Spacing.small,
            distribution: .fillProportionally
        )
        result.setCustomSpacing(DesignSystem.Spacing.GDSList.betweenRows, after: titleLabel)
        return result
    }()
    
    private var maxNumberWidth: CGFloat {
        viewModel.style == .numbered ?
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
        : 0
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
        listStackView.addArrangedSubview(titleLabel)
        listStackView.setCustomSpacing(DesignSystem.Spacing.GDSList.betweenRows, after: titleLabel)
        newRows.forEach {
            self.listStackView.addArrangedSubview($0)
        }
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        addSubview(listStackView)
        listStackView.bindToSuperviewEdges()
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
        let label = UILabel(colour: DesignSystem.Color.GDSList.label)
        label.font = DesignSystem.Font.Base.body
        
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
    
    private func createRow(marker: UIView, label: UIView) -> UIStackView {
        let row = UIStackView(
            views: [marker, label],
            axis: .horizontal,
            spacing: DesignSystem.Spacing.GDSList.beforeLabel,
            alignment: viewModel.style == .numbered ? .top : .center,
            distribution: .fill
        )
        
        row.isLayoutMarginsRelativeArrangement = true
        row.layoutMargins.left = DesignSystem.Spacing.GDSList.leadingMargin
        
        row.isAccessibilityElement = true
        return row
    }
    
    private func createNumberedlist() -> [UIStackView] {
        return viewModel.items
            .enumerated()
            .map { index, item in
                let indexIncremented = index + 1
                let marker = UILabel(colour: DesignSystem.Color.GDSList.marker)
                marker.text = "\(indexIncremented)."
                marker.font = DesignSystem.Font.Base.body
                marker.widthAnchor.constraint(equalToConstant: maxNumberWidth).isActive = true
                
                let label = contentLabels(for: item)
                
                let row = createRow(marker: marker, label: label)
                
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
        
        return viewModel.items
            .enumerated()
            .map { index, item in
            let bullet = UIImageView(image: bulletSymbol)
            bullet.tintColor = DesignSystem.Color.GDSList.marker
            bullet.setContentHuggingPriority(.required, for: .horizontal)
            bullet.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            let label = contentLabels(for: item)

            let row = createRow(marker: bullet, label: label)
                
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
