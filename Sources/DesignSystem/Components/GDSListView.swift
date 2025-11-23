import UIKit

public final class GDSListView<ViewModel: GDSListViewModel>: UIView, ContentView {
    public typealias ViewType = ViewModel
    
    let viewModel: ViewModel
    
    private lazy var containerStackView: UIStackView = {
        let result = UIStackView(
            views: [
                titleLabel,
                listStackView
            ],
            spacing: 12,
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
            spacing: 8,
            distribution: .fillProportionally
        )
        result.isLayoutMarginsRelativeArrangement = true
        result.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
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
    
    public required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        backgroundColor = .systemBackground
        addSubview(containerStackView)
        containerStackView.bindToSuperviewEdges()
        containerStackView.addArrangedSubview(listStackView)
        
        switch viewModel.style {
            case .numbered:
                createNumberedlist()
            case .bulleted:
                createBulletedList()
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func createNumberedlist() {
        let rows = viewModel.items.enumerated()
            .map { index, string in
                let indexIncremented = index + 1
                let listRowStack = UIStackView(
                    views: [
                        {
                            let number = UILabel()
                            number.text = "\(indexIncremented)."
                            number.font = DesignSystem.Font.Base.body
                            number.textAlignment = .right
                            number.adjustsFontForContentSizeCategory = true
                            number.widthAnchor.constraint(equalToConstant: maxNumberWidth).isActive = true
                            return number
                        }(),
                        {
                            let content = UILabel()
                            content.font = DesignSystem.Font.Base.body
                            if let attributedString = string.attributedValue {
                                content.attributedText = attributedString
                            } else {
                                content.text = string.value
                            }
                            content.numberOfLines = 0
                            content.textAlignment = .left
                            content.adjustsFontForContentSizeCategory = true
                            return content
                        }()
                    ],
                    axis: .horizontal,
                    spacing: 20,
                    alignment: .top,
                    distribution: .fill
                )
                listRowStack.isAccessibilityElement = true
                listRowStack.accessibilityLabel = {
                    let summaryLabel = GDSLocalisedString(
                        stringKey: "NumberedList",
                        String(viewModel.items.count),
                        bundle: .module
                    )
                    let number = NSLocalizedString(
                        key: String(indexIncremented),
                        bundle: .module
                    )
                    let listLabel = "\(number), \(string.value)"
                    return indexIncremented == 1 ? "\(summaryLabel.value) \(listLabel)" : listLabel
                }()
                listRowStack.accessibilityIdentifier = "numbered-list-row-stack-view-\(indexIncremented)"
                return listRowStack
            }
        
        rows.forEach { listStackView.addArrangedSubview($0) }
    }
    
    private func createBulletedList() {
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        let scaledSize = fontMetrics.scaledValue(for: 6)
        let bulletSymbol = UIImage(systemName: "circle.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: scaledSize, weight: .semibold)
        )
        
        let rows = viewModel.items.enumerated().map { index, item in
            let listRowStack = UIStackView(
                views: [
                    {
                        let bullet = UIImageView(image: bulletSymbol)
                        bullet.tintColor = .label
                        bullet.setContentHuggingPriority(.required, for: .horizontal)
                        bullet.setContentCompressionResistancePriority(.required, for: .horizontal)
                        return bullet
                    }(),
                    {
                        let textLabel = UILabel()
                        textLabel.numberOfLines = 0
                        textLabel.font = DesignSystem.Font.Base.body
                        textLabel.adjustsFontForContentSizeCategory = true
                        
                        if let attributed = item.attributedValue {
                            textLabel.attributedText = attributed
                        } else {
                            textLabel.text = item.value
                        }
                        return textLabel
                    }()
                ],
                axis: .horizontal,
                spacing: 20,
                alignment: .top,
                distribution: .fill
            )
            
            listRowStack.isAccessibilityElement = true
            let summaryLabel = GDSLocalisedString(
                stringKey: "BulletedList",
                String(viewModel.items.count),
                bundle: .module
            )
            let listLabel = item.value
            listRowStack.accessibilityLabel = index == 0
            ? "\(summaryLabel) \(listLabel)"
            : listLabel
            
            listRowStack.accessibilityIdentifier = "bulleted-list-row-stack-view-\(index + 1)"
            
            return listRowStack
        }
        
        rows.forEach { listStackView.addArrangedSubview($0) }
    }
}
