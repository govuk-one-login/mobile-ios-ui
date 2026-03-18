import UIKit

public final class GDSStatusOverlay: UIView, ContentView {
    private let viewModel: GDSStatusOverlayViewModel
    
    private lazy var iconView: UIImageView = {
        let font = viewModel.iconStyle?.font ?? UIFont.systemFont(ofSize: 65, weight: .thin)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
        let config = UIImage.SymbolConfiguration(font: scaledFont)
        
        let iconView = UIImageView(image: UIImage(
            systemName: viewModel.iconStyle?.icon ?? "checkmark.circle",
            withConfiguration: config
        ))
        iconView.tintColor = viewModel.iconStyle?.colour ?? DesignSystem.Color.Icons.statusOverlay
        iconView.contentMode = .center
        
        iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iconView.isAccessibilityElement = false
        iconView.accessibilityIdentifier = "status-overlay-icon"
        
        return iconView
    }()
    
    private lazy var titleView: GDSTextView = {
        GDSTextView(viewModel: viewModel.statusOverlayText)
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleView])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = DesignSystem.Spacing.default
        stack.backgroundColor = DesignSystem.Color.Backgrounds.statusOverlay
        
        stack.layer.cornerRadius = DesignSystem.CornerRadius.small
        stack.layer.masksToBounds = true
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 30, left: 8, bottom: 20, right: 8)
        
        stack.isAccessibilityElement = true
        stack.shouldGroupAccessibilityChildren = true
        stack.accessibilityLabel = viewModel.accessibilityLabel
        stack.accessibilityTraits = [.none]
        stack.accessibilityIdentifier = "status-overlay-stack-view"
        
        return stack
    }()
    
    public init(viewModel: GDSStatusOverlayViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.widthAnchor.constraint(equalToConstant: 200),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func present(onView view: UIView) async {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Hide background from VoiceOver
        view.accessibilityElementsHidden = true
//
//        // Make overlay accessible
//        self.accessibilityViewIsModal = true
//        self.accessibilityElements = [stackView]
        
        self.isAccessibilityElement = false
        self.accessibilityViewIsModal = true
        self.accessibilityElements = [stackView]

        // Ensure VoiceOver focuses the overlay
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .screenChanged, argument: self.stackView)
        }

        try? await Task.sleep(seconds: 4.0)
        
        self.removeFromSuperview()
        // Restore accessibility
        view.accessibilityElementsHidden = false
    }
    
    
    public func presentOverlayWhileScreenTransition() {
        // Use apps window instead of its navigationController
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: window.centerYAnchor)
        ])
        
        // Hide background from VoiceOver
        window.accessibilityElementsHidden = true
        
        // Trap VoiceOver inside overlay
        window.accessibilityViewIsModal = true
        window.accessibilityElements = [stackView]
        
        // Ensure VoiceOver focuses the overlay
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .screenChanged, argument: self.stackView)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.removeFromSuperview()
            // Restore accessibility
            window.accessibilityElementsHidden = false
        }
    }
    
//    public func present(onView view: UIView) {
//        translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(self)
//        
//        NSLayoutConstraint.activate([
//            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        
//        // Hide background from VoiceOver
//        view.accessibilityElementsHidden = true
//        
//        // Trap VoiceOver inside overlay
//        self.accessibilityViewIsModal = true
//        self.accessibilityElements = [stackView]
//        
//        // Ensure VoiceOver focuses the overlay
//        DispatchQueue.main.async {
//            UIAccessibility.post(notification: .screenChanged, argument: self.stackView)
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
//            self?.removeFromSuperview()
//            // Restore accessibility
//            view.accessibilityElementsHidden = false
//        }
//    }
}

public final class GDSStatusViewController: UIViewController {
    private let statusOverlay: GDSStatusOverlay
    private let duration: TimeInterval
    
    public init(statusOverlay: GDSStatusOverlay,
                duration: TimeInterval = 4) {
        self.statusOverlay = statusOverlay
        self.duration = duration
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(statusOverlay)
        statusOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        statusOverlay.accessibilityElements = [statusOverlay]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
