import UIKit

/// `BaseScreen` provides standard lifecycle functionality for other view controllers to inherit from
/// The view controller is configured with a  `BaseViewModel`
/// For the functionality of `BaseScreen` to work, the concrete implementation of
/// view model must conform to `BaseViewModel`.
/// Screen view controllers should generally inherit from ``BaseScreen`` instead of `UIViewController`
/// unless the functionality of the screen needs to be intentionally different from standard screens.
open class BaseScreen: UIViewController {
    private let viewModel: BaseViewModel?
    
    public private(set) var appearAsyncTask: Task<Void, Never>? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    public private(set) var dismissAsyncTask: Task<Void, Never>? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    public init(viewModel: BaseViewModel?, nibName: String? = nil, bundle: Bundle?) {
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
        
        // Sets this screen's own `backButtonTitle`, which UIKit uses for the back
        // button of any screen pushed on top of this one (including non-BaseScreens,
        // which don't go through `applyBackButtonTitleToPreviousScreen`). Also applies
        // `hidesBackButton`. Don't remove as redundant with `willMove(toParent:)`.
        setBackButtonTitle(
            title: viewModel?.backButtonTitle,
            isHidden: viewModel?.backButtonIsHidden ?? false
        )
        
        configureLeftBarButtons()
        configureRightBarButtons()
    }
    
    open override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        // From iOS 26 the back button is a text-less glass chevron, so the
        // title only needs to be provided on earlier versions.
        guard #unavailable(iOS 26.0),
              let navigationController = parent as? UINavigationController else {
            return
        }
        applyBackButtonTitleToPreviousScreen(in: navigationController)
    }
    
    /// UIKit sources a back button's title from the `navigationItem` of the screen
    /// being returned to, not from the screen being pushed. Setting
    /// `backButtonTitle` on this screen alone therefore has no effect on its own
    /// back button, which falls back to a UIKit-provided title that has no
    /// translation for some languages (e.g. Welsh).
    ///
    /// This applies the view model's title to the previous screen so the
    /// back button uses the app's own localised string.
    ///
    /// This intentionally overwrites any `backButtonTitle` already set on the
    /// previous screen (including the one it set for itself in `viewWillAppear`):
    /// the title of the screen being pushed always wins for its own back button.
    /// Nothing is applied if the back button is hidden or the view model has no title.
    private func applyBackButtonTitleToPreviousScreen(
        in navigationController: UINavigationController
    ) {
        guard viewModel?.backButtonIsHidden != true,
              let title = viewModel?.backButtonTitle else {
            return
        }
        
        let stack = navigationController.viewControllers
        // `willMove(toParent:)` can run before or after this screen is in the stack.
        let previous: UIViewController?
        if let index = stack.firstIndex(of: self) {
            previous = index > 0 ? stack[index - 1] : nil
        } else {
            previous = stack.last
        }
        previous?.navigationItem.backButtonTitle = title.value
    }
    
    open override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        Task { @MainActor in
            if let screen = self as? VoiceOverFocus {
                UIAccessibility.post(
                    notification: .screenChanged,
                    argument: try screen.initialVoiceOverView
                )
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch viewModel?.didAppear {
        case .action(let action):
            action()
        case .asyncAction(let asyncAction):
            appearAsyncTask = Task {
                await asyncAction()
            }
        case .none:
            return
        }
    }
    
    @objc private func dismissScreen() {
        self.dismiss(animated: true)
        
        switch viewModel?.didDismiss {
        case .action(let action):
            action()
        case .asyncAction(let asyncAction):
            dismissAsyncTask = Task {
                await asyncAction()
            }
        case .none:
            return
        }
    }
}

// MARK: - Bar Button Configuration

extension BaseScreen {
    private func configureLeftBarButtons() {
        guard let configs = viewModel?.leftBarButtons else { return }
        navigationItem.leftBarButtonItems = configs.map { makeBarButtonItem(from: $0) }
    }

    private func configureRightBarButtons() {
        // New declarative API takes precedence
        if let configs = viewModel?.rightBarButtons {
            navigationItem.rightBarButtonItems = configs.map { makeBarButtonItem(from: $0) }
            return
        }

        // Legacy fallback: rightBarButtonTitle creates a dismiss button
        if viewModel?.rightBarButtonTitle != nil {
            navigationItem.rightBarButtonItem = .init(
                title: viewModel?.rightBarButtonTitle?.value,
                style: .plain,
                target: self,
                action: #selector(dismissScreen)
            )
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = "right-bar-button"
        }
    }

    private func makeBarButtonItem(
        from config: DesignSystem.NavigationBarButton
    ) -> UIBarButtonItem {
        let item: UIBarButtonItem

        switch config.content {
        case .button(let title, let image, let style):
            let uiAction = UIAction(title: title ?? "") { _ in config.action?() }
            if let image {
                item = UIBarButtonItem(image: image, primaryAction: uiAction)
            } else {
                item = UIBarButtonItem(primaryAction: uiAction)
                item.style = style
            }

        case .menu(let image, let menuProvider):
            let deferredElement = UIDeferredMenuElement.uncached { completion in
                menuProvider(completion)
            }
            let menu = UIMenu(children: [deferredElement])
            item = UIBarButtonItem(image: image, menu: menu)
        }

        item.accessibilityIdentifier = config.accessibilityIdentifier
        return item
    }
}

extension UIViewController {
    public func setBackButtonTitle(
        title: GDSLocalisedString?,
        isHidden: Bool = false
    ) {
        if let title {
            navigationItem.backButtonTitle = title.value
        }
        navigationItem.hidesBackButton = isHidden
    }
}
