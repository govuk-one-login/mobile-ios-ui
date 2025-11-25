import UIKit

public final class GDSMultiRow: UIView, ContentView {
    let viewModel: GDSMultiRowViewModel
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
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
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func applyRows() {
        for (index, row) in viewModel.rows.enumerated() {
            let rowView = GDSRow(viewModel: row)
            verticalStack.addArrangedSubview(rowView)
            
            if index < viewModel.rows.count - 1 {
                let divider = UIView()
                divider.backgroundColor = DesignSystem.Color.Dividers.default
                divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
//                divider.leadingAnchor.constraint(equalTo: rowView.verticalStack.leadingAnchor).isActive = true
                verticalStack.addArrangedSubview(divider)
            }
        }
    }
}
