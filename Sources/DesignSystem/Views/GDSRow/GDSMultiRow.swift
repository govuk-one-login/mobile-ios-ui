import UIKit

public final class GDSMultiRow: UIView, ContentView {
    let viewModel: GDSMultiRowViewModel
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public init(viewModel: GDSMultiRowViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        applyRows()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = viewModel.backgroundColor
        layer.cornerRadius = viewModel.cornerRadius
        addSubview(verticalStack)
        verticalStack.bindToSuperviewEdges()
    }
    
    func applyRows() {
        for row in viewModel.rows {
            let rowView = GDSRow(viewModel: row)
            verticalStack.addArrangedSubview(rowView)
            
            if viewModel.rows.last?.id != row.id {
                rowView.addDivider()
            }
        }
    }
}
