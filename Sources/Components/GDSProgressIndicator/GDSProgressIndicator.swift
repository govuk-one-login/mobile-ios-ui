import UIKit

public final class GDSProgressIndicator: UIView, ContentView {
    let viewModel: GDSProgressIndicatorViewModel
    private var didScheduleTitleChanges = false
    
    public lazy var iconView: UIActivityIndicatorView = {
        let iconView = UIActivityIndicatorView(style: .large)
        
        iconView.color = viewModel.progressIndicatorColor
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        return iconView
    }()
    
    public lazy var titleView: GDSTextView = {
        GDSTextView(viewModel: viewModel.title)
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleView])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = DesignSystem.Spacing.default
        stack.distribution = .equalSpacing
  
        stack.isAccessibilityElement = true
        stack.shouldGroupAccessibilityChildren = true
        stack.accessibilityLabel = viewModel.title.title.value // TODO: fix voiceover
        stack.accessibilityIdentifier = "progress-indicator-stack-view"
        
        return stack
    }()
    
    public init(viewModel: GDSProgressIndicatorViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Animate progress indicator
        iconView.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        if !didScheduleTitleChanges {
            didScheduleTitleChanges = true
            scheduleTitleChanges()
        }
    }

    private func scheduleTitleChanges() {
        // Schedule title change after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            let fiveSecondTitle = GDSTextView(viewModel: self.viewModel.titleAfter5Seconds)
            self.replaceTitleView(with: fiveSecondTitle)
        }

        // Schedule title change after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self else { return }
            let tenSecondTitle = GDSTextView(viewModel: self.viewModel.titleAfter10Seconds)
            self.replaceTitleView(with: tenSecondTitle)
        }
    }
    
    private func replaceTitleView(with newTitleView: GDSTextView) {
        // remove current title from stack
        stackView.removeArrangedSubview(titleView)
        titleView.removeFromSuperview()

        // replace title reference and back to stack
        titleView = newTitleView
        stackView.addArrangedSubview(titleView)

        // force layout update
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()
        
        // voiceover annouces new title
        UIAccessibility.post(notification: .layoutChanged, argument: titleView)
    }
}
