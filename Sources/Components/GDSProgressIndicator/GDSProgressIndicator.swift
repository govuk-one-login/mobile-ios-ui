import UIKit

public final class GDSProgressIndicator: UIView, ContentView {
    let viewModel: GDSProgressIndicatorViewModel
    private var didScheduleTitleChanges = false
    
    public lazy var iconView: UIActivityIndicatorView = {
        let iconView = UIActivityIndicatorView(style: .large)
        
        iconView.color = viewModel.progressIndicatorColor
        
        return iconView
    }()
    
    public lazy var titleView: GDSTextView = {
        GDSTextView(viewModel: viewModel.title)
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleView])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = DesignSystem.Spacing.default
  
        stack.isAccessibilityElement = true
        stack.shouldGroupAccessibilityChildren = true
        stack.accessibilityLabel = viewModel.title.title.value
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
            self.replaceTitleView(with: self.viewModel.titleAfter5Seconds)
        }

        // Schedule title change after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self else { return }
            self.replaceTitleView(with: self.viewModel.titleAfter10Seconds)
        }
    }
    
    private func replaceTitleView(with newTitleView: GDSTextViewModel) {
        // remove current title from stack
        stackView.removeArrangedSubview(titleView)
        titleView.removeFromSuperview()

        // replace title reference and back to stack
        titleView = GDSTextView(viewModel: newTitleView)
        stackView.addArrangedSubview(titleView)

        // force layout update
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()
        
        // voiceover annouces new title
        stackView.accessibilityLabel = newTitleView.title.value
        UIAccessibility.post(notification: .announcement, argument: newTitleView.title.value)
    }
}
