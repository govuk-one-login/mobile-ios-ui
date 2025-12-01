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
        result.accessibilityIdentifier = "list-title-label"
        return result
    }()
    
    private lazy var listStackView: UIStackView = {
        let views = list()
        let result = UIStackView(
            views: [],
            spacing: DesignSystem.Spacing.small,
            distribution: .fill
        )
        result.addArrangedSubview(titleLabel)
        result.setCustomSpacing(DesignSystem.Spacing.GDSList.betweenRows, after: titleLabel)
        views.forEach {
            result.addArrangedSubview($0)
        }
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
    
    private var singleLineHeight: CGFloat {
        let number = UILabel()
        number.text = "Label"
        number.font = DesignSystem.Font.Base.body
        number.adjustsFontForContentSizeCategory = true
        return number.intrinsicContentSize.height
    }
    
    private var bulletHeight: CGFloat {
        let bullet = bulletMarker()
        return bullet.intrinsicContentSize.height
    }
    
    private var bulletImage: UIImage? {
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        let scaledSize = fontMetrics.scaledValue(for: 6)
        return UIImage(systemName: "circle.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: scaledSize, weight: .semibold)
        )
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
        
        let newRows = self.list()
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
        reloadListView()
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
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            reloadListView()
        }
    }
    
    private func list() -> [UIStackView] {
        return viewModel.items
            .enumerated()
            .map { index, item in
                let rowNumber = index + 1
                
                let marker = viewModel.style == .numbered
                ? numberMarker(for: rowNumber)
                : bulletMarker()
                let label = contentLabels(for: item)
                let row = createRow(marker: marker, label: label)
                
                let summaryLabel = GDSLocalisedString(
                    stringKey: viewModel.style == .numbered
                    ? "Numbered List"
                    : "Bulleted List",
                    bundle: .module
                )
                
                let itemCount = "\(viewModel.items.count) items"
                
                let number = NSLocalizedString(
                    key: String(rowNumber),
                    bundle: .module
                )
                let markerLabel = viewModel.style == .numbered
                    ? number : "bullet"
                
                let listLabel = "\(markerLabel), \(item.value)"
                
                row.accessibilityLabel = index == 0
                ? "\(summaryLabel) \(itemCount), \(listLabel)"
                : listLabel
                
                row.accessibilityIdentifier = viewModel.style == .numbered
                ? "numbered-list-row-stack-view-\(rowNumber)"
                : "bulleted-list-row-stack-view-\(rowNumber)"
                
                return row
            }
    }
    
    private func bulletMarker() -> UIView {
        let bullet = UIImageView(image: bulletImage)
        bullet.tintColor = DesignSystem.Color.GDSList.marker
        bullet.contentMode = .scaleAspectFit
        bullet.setContentHuggingPriority(.defaultLow, for: .horizontal)
        bullet.setContentHuggingPriority(.defaultLow, for: .vertical)
        bullet.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return bullet
    }
    
    private func numberMarker(for number: Int) -> UIView {
        let marker = UILabel(colour: DesignSystem.Color.GDSList.marker)
        marker.text = "\(number)."
        marker.textAlignment = .right
        marker.font = DesignSystem.Font.Base.body
        marker.widthAnchor.constraint(equalToConstant: maxNumberWidth).isActive = true
        return marker
    }
    
    private func createRow(marker: UIView, label: UIView) -> UIStackView {
        let row = UIStackView(
            views: [marker, label],
            axis: .horizontal,
            spacing: DesignSystem.Spacing.GDSList.beforeLabel,
            alignment: .top,
            distribution: .fill
        )
        
        if viewModel.style == .bulleted {
            NSLayoutConstraint.activate(
                [
                    marker.heightAnchor.constraint(equalToConstant: bulletHeight),
                    marker.widthAnchor.constraint(equalToConstant: bulletHeight),
                    marker.centerYAnchor.constraint(equalTo: label.topAnchor, constant: singleLineHeight / 2)
                ]
            )
        }
        
        row.isLayoutMarginsRelativeArrangement = true
        row.layoutMargins.left = DesignSystem.Spacing.GDSList.leadingMargin
        
        row.isAccessibilityElement = true
        return row
    }
}
