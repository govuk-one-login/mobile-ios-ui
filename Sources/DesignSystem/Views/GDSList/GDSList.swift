import UIKit

public final class GDSList: UIView, ContentView, UITextViewDelegate {
    public let viewModel: GDSListViewModel
    var rowContainsLink: Bool = false
    var rowContainsSymbol: Bool = false
    
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
    
    private func contentLabels(
        for item: GDSLocalisedString
    ) -> UITextView {
        // Ensures UITextView has the correct color and font
        let textView = UITextView()
        textView.textColor = DesignSystem.Color.GDSList.label
        textView.font = DesignSystem.Font.Base.body
        
        // Prevents UITextView from applying its default styling
        textView.linkTextAttributes = [:]
        
        // Configure UITextView
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.adjustsFontForContentSizeCategory = true
        textView.isEditable = false
        
        // Allows the UITextView to detect taps
        textView.isSelectable = true
        textView.delegate = self
        
        // Checking if theres a symbol
        if item.stringAttributes?.symbol != nil {
            rowContainsSymbol = true
        } else {
            rowContainsSymbol = false
        }
        
        if let attributedString = item.attributedValue {
            // Check if attributedString has a link
            let fullRange = NSRange(location: 0, length: attributedString.length)
            attributedString.enumerateAttributes(
                in: fullRange,
                options: []
            ) { (attributes, _, stop) in
                if attributes[.link] != nil {
                    rowContainsLink = true
                    stop.pointee = true
                }
            }
            
            textView.attributedText = attributedString
        } else {
            rowContainsLink = false
            textView.text = item.value
        }
        
        return textView
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        // Prevents users from highlighting text
        if textView.selectedTextRange != nil {
            textView.selectedTextRange = nil
        }
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
                let textView = contentLabels(for: item)
                let row = createRow(marker: marker, label: textView)
                
                let itemCount = String(viewModel.items.count)
                
                let summaryLabel = GDSLocalisedString(
                    stringKey: viewModel.style == .numbered
                    ? "numberedList"
                    : "bulletedList",
                    variableKeys: [itemCount],
                    bundle: .designSystem
                )
                
                let number = NSLocalizedString(
                    key: String(rowNumber),
                    bundle: .module
                )
                let markerLabel = viewModel.style == .numbered
                ? number : GDSLocalisedString(stringKey: "bullet", bundle: .designSystem).value
                
                let listLabel = "\(markerLabel), \(item.value)"
                
                row.accessibilityLabel = index == 0
                ? "\(summaryLabel), \(listLabel)"
                : listLabel
                
                if rowContainsSymbol {
                    row.accessibilityHint = GDSLocalisedString(stringKey: "externalLinkAccessibilityHint",
                                                               bundle: .designSystem).value
                }
                
                row.accessibilityIdentifier = viewModel.style == .numbered
                ? "numbered-list-row-stack-view-\(rowNumber)"
                : "bulleted-list-row-stack-view-\(rowNumber)"
                
                row.accessibilityRespondsToUserInteraction = false
                
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
        
        // Only add link attribute if row has link
        if rowContainsLink {
            row.accessibilityTraits = .link
        }
        
        row.isLayoutMarginsRelativeArrangement = true
        row.layoutMargins.left = DesignSystem.Spacing.GDSList.leadingMargin
        row.isAccessibilityElement = true
        
        return row
    }
}
