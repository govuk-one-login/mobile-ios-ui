import UIKit

/// `BaseViewController` provides standard lifecycle functionality for other view controllers to inherit from
/// The view controller is configured with a  `BaseViewModel`
/// For the functionality of `BaseViewController` to work, the concrete implementation of
/// view model must conform to `BaseViewModel`.
/// Screen view controllers should generally inherit from ``BaseViewController`` instead of `UIViewController`
/// unless the functionality of the screen needs to be intentionally different from standard screens.
open class BaseViewController: UIViewController {
    private let viewModel: BaseViewModel?
    
    public init(viewModel: BaseViewModel?, bundle: Bundle?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: bundle)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setBackButtonTitle(
            title: viewModel?.backButtonTitle,
            isHidden: viewModel?.backButtonIsHidden ?? false
        )
        
        if viewModel?.rightBarButtonTitle != nil {
            self.navigationItem.rightBarButtonItem = .init(title: viewModel?.rightBarButtonTitle?.value,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(dismissScreen))
            self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "right-bar-button"
        }
    }
    
    open override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        Task { @MainActor in
            if let screen = self as? VoiceOverFocus {
                UIAccessibility.post(notification: .screenChanged,
                                     argument: try screen.initialVoiceOverView)
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.didAppear()
    }
    
    @objc private func dismissScreen() {
        self.dismiss(animated: true)
        viewModel?.didDismiss()
    }
}

extension UIViewController {
    func setBackButtonTitle(
        title: GDSLocalisedString?,
        isHidden: Bool = false
    ) {
        if let title {
            navigationItem.backButtonTitle = title.value
        }
        navigationItem.hidesBackButton = isHidden
    }
}
