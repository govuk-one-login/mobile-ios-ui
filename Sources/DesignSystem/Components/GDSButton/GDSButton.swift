import UIKit

public final class GDSButton: UIButton, ContentView {
    let viewModel: GDSButtonViewModel
    
    public private(set) var asyncTask: Task<Void, Never>?
    
    var isLoading: Bool = false {
        didSet {
            var config = self.configuration
            config?.showsActivityIndicator = isLoading
            self.isEnabled = !isLoading
            self.configuration = config
            self.setNeedsUpdateConfiguration()
        }
    }
    
    var isVoiceOverFocussed: Bool = false
    
    public init(
        viewModel: GDSButtonViewModel
    ) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configuration = .gds
        self.configurationUpdateHandler = UIButton.buttonUpdater(viewModel: viewModel)
        
        self.configuration?.title = viewModel.title.forState(.normal)
        
        switch viewModel.buttonAction {
        case .action(let action):
            self.addAction(
                createAction(viewModel: viewModel, action: action),
                for: .touchUpInside
            )
        case .asyncAction(let action):
            self.addAction(
                createAsyncAction(viewModel: viewModel, action: action),
                for: .touchUpInside
            )
        }
        
        if let minHeight = viewModel.style.minimumHeight {
            NSLayoutConstraint.activate(
                [
                    self.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
                ]
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createAction(viewModel: GDSButtonViewModel, action: @escaping () -> Void) -> UIAction {
        UIAction(
            handler: { [unowned self] _ in
                action()
                
                if selectedState(viewModel: viewModel) {
                    self.isSelected.toggle()
                }
                
                if let haptic = viewModel.haptic {
                    haptic.perform()
                }
            }
        )
    }
    
    private func createAsyncAction(viewModel: GDSButtonViewModel, action: @escaping () async -> Void) -> UIAction {
        UIAction(
            handler: { handler in
                var handlerButton: GDSButton? = handler.sender as? GDSButton
                handlerButton?.asyncTask = Task { @MainActor in
                    guard let button = handlerButton else { return }
                    let constraint: NSLayoutConstraint? = button.heightAnchor.constraint(equalToConstant: button.bounds.height)
                    constraint?.isActive = true
                    
                    button.isLoading = true
                    await action()
                    
                    if button.selectedState(viewModel: viewModel) {
                        button.isSelected.toggle()
                    }
                    
                    if let haptic = viewModel.haptic {
                        haptic.perform()
                    }
                    button.isLoading = false
                    
                    constraint?.isActive = false
                    handlerButton = nil
                }
            }
        )
    }
    
    func selectedState(viewModel: GDSButtonViewModel) -> Bool {
        if viewModel.title.isSelectable ||
            viewModel.style.backgroundColor.isSelectable ||
            viewModel.style.foregroundColor.isSelectable ||
            (viewModel.icon?.isSelectable == true) {
            return true
        } else {
            return false
        }
    }
    
    public override func accessibilityElementDidLoseFocus() {
        super.accessibilityElementDidLoseFocus()
        self.setNeedsUpdateConfiguration()
    }
    
    public override func accessibilityElementDidBecomeFocused() {
        super.accessibilityElementDidBecomeFocused()
        var config = self.configuration
        config?.baseBackgroundColor = viewModel.style.backgroundColor.forState(.focused)
        config?.baseForegroundColor = viewModel.style.foregroundColor.forState(.focused)
        self.configuration = config
        if viewModel.icon == .arrowUpRight {
            self.accessibilityHint = "Opens in web browser"
        }
    }
}
