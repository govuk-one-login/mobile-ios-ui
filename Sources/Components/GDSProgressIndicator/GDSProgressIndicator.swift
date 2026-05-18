import UIKit

public final class GDSProgressIndicator: UIView, ContentView {
    let viewModel: GDSProgressIndicatorViewModel
    private var didScheduleTitleChanges = false
    
    public lazy var iconView: UIActivityIndicatorView = {
        let iconView = UIActivityIndicatorView(style: .large)
        
        // Default color to be used unless defined
        if let color = viewModel.progressIndicatorColor {
            iconView.color = color
        }
        
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
        
        let defaultTitle = viewModel.title.title.value
        UIAccessibility.post(notification: .screenChanged, argument: defaultTitle)
        stack.accessibilityLabel = defaultTitle
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
            
            let titleAfter5Seconds = viewModel.titleAfter5Seconds.title.value
            titleView.text = titleAfter5Seconds
            
            // Update accessiblityLabel and have voiceover annouce new title
            stackView.accessibilityLabel = titleAfter5Seconds
            UIAccessibility.post(notification: .layoutChanged, argument: stackView)
        }

        // Schedule title change after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self else { return }
            
            let titleAfter10Seconds = viewModel.titleAfter10Seconds.title.value
            titleView.text = titleAfter10Seconds
            
            // Update accessiblityLabel and have voiceover annouce new title
            stackView.accessibilityLabel = titleAfter10Seconds
            UIAccessibility.post(notification: .layoutChanged, argument: stackView)
        }
    }
}
