import DesignSystem
import UIKit

/// A demo ContentViewModel that embeds a UICollectionView as body content
/// to demonstrate the .fullHeight GDSScreenStyle with self-scrolling content.
struct DemoCollectionViewContentViewModel: ContentViewModel {
    typealias ViewType = DemoCollectionContentView
    
    let verticalPadding: VerticalPadding? = .vertical(0)
    let horizontalPadding: HorizontalPadding? = .horizontal(0)
    let accessibilityIdentifier: String? = "demo-collection-view"
    let accessibilityTraits: UIAccessibilityTraits? = nil
    let items: [String]
}

/// A demo-only ContentView that wraps a UICollectionView
final class DemoCollectionContentView: UIView, ContentView {
    typealias Content = DemoCollectionViewContentViewModel
    
    private let collectionView: UICollectionView
    private let items: [String]
    
    required init(viewModel: DemoCollectionViewContentViewModel) {
        self.items = viewModel.items
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 200, height: 60)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        
        collectionView.register(DemoCell.self, forCellWithReuseIdentifier: "DemoCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DemoCollectionContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCell", for: indexPath) as? DemoCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

extension DemoCollectionContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let width = collectionView.bounds.width - insets.left - insets.right
        return CGSize(width: width, height: 60)
    }
}

/// Simple demo cell with a label
private final class DemoCell: UICollectionViewCell {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        label.text = text
    }
}
