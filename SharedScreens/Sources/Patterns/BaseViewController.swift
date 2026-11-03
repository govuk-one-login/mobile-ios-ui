import DesignSystem
import UIKit

/// `BaseViewController` provides standard lifecycle functionality for other view controllers to inherit from
/// The view controller is configured with a  `SharedScreensBaseViewModel`
/// For the functionality of `BaseViewController` to work, the concrete implementation of
/// view model must conform to `SharedScreensBaseViewModel`.
/// Screen view controllers should generally inherit from ``BaseViewController`` instead of `UIViewController`
/// unless the functionality of the screen needs to be intentionally different from standard screens.
open class BaseViewController: UIViewController {
    private let viewModel: SharedScreensBaseViewModel?
    
    public init(
        viewModel: SharedScreensBaseViewModel?,
        nibName: String? = nil,
        bundle: Bundle? = nil
    ) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setBackButtonTitle(
            title: GDSLocalisedString(stringKey: "GDSCommonBackButton", bundle: .module),
            isHidden: viewModel?.backButtonIsHidden ?? false
        )
        
        if viewModel?.rightBarButtonTitle != nil {
            self.navigationItem.rightBarButtonItem = .init(title: viewModel?.rightBarButtonTitle?.value,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissScreen))
            self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "right-bar-button"
        }
    }
    
    open override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        Task { @MainActor in
            if let screen = self as? VoiceOverFocus,
               let focusView = try? screen.initialVoiceOverView {
                UIAccessibility.post(notification: .screenChanged,
                                     argument: focusView)
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
