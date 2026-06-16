import UIKit

public final class GDSProgressIndicator: UIView, ContentView {
    let viewModel: GDSProgressIndicatorViewModel
    private var workItems: [DispatchWorkItem] = []
    
    public lazy var iconView: UIActivityIndicatorView = {
        let iconView = UIActivityIndicatorView(style: .large)
        
        // Default color to be used unless defined
        if let color = viewModel.progressIndicatorColor {
            iconView.color = color
        }
        
        iconView.isAccessibilityElement = false
        return iconView
    }()
    
    public lazy var titleView: GDSTextView = {
        let titleView = GDSTextView(viewModel: viewModel.title)
        titleView.isAccessibilityElement = false
        return titleView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleView])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = DesignSystem.Spacing.default
        
        stack.isAccessibilityElement = true
        stack.accessibilityLabel = viewModel.title.title.value
        if let accessibilityTraits = viewModel.accessibilityTraits {
            stack.accessibilityTraits = accessibilityTraits
        }
        stack.accessibilityIdentifier = viewModel.accessibilityIdentifier ?? "progress-indicator-stack-view"
        
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
    
    // Title changes are only called once component has been added to window
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            scheduleTitleChanges()
        } else {
            cancelTitleChanges()
        }
    }
    
    private func scheduleTitleChanges() {
        // Ensures that when component is on screen again the default title is displayed and not the last
        let defaultTitle = viewModel.title.title.value
        titleView.text = defaultTitle
        stackView.accessibilityLabel = defaultTitle
        
        let titleAfter5Seconds = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let titleAfter5Seconds = viewModel.titleAfter5Seconds.title.value
            titleView.text = titleAfter5Seconds
            
            // Update accessiblityLabel and have voiceover annouce new title
            stackView.accessibilityLabel = titleAfter5Seconds
            UIAccessibility.post(notification: .layoutChanged, argument: stackView)
        }
        
        let titleAfter10Seconds = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let titleAfter10Seconds = viewModel.titleAfter10Seconds.title.value
            titleView.text = titleAfter10Seconds
            
            // Update accessiblityLabel and have voiceover annouce new title
            stackView.accessibilityLabel = titleAfter10Seconds
            UIAccessibility.post(notification: .layoutChanged, argument: stackView)
        }
        
        workItems = [titleAfter5Seconds, titleAfter10Seconds]
        
        // Schedule title change after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: titleAfter5Seconds)
        // Schedule title change after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: titleAfter10Seconds)
    }
    
    private func cancelTitleChanges() {
        workItems.forEach { $0.cancel() }
        workItems.removeAll()
    }
}
