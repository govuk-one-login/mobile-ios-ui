import UIKit

public final class GDSButton: UIButton {
    let viewModel: GDSButtonViewModel
    
    var isLoading: Bool = false {
        didSet {
            var config = self.configuration
            config?.showsActivityIndicator = isLoading
            self.isEnabled = !isLoading
            self.configuration = config
            self.setNeedsUpdateConfiguration()
        }
    }
    
    public init(
        viewModel: GDSButtonViewModel
    ) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configuration = .gds
        self.configurationUpdateHandler = UIButton.buttonUpdater(viewModel: viewModel)
        
        self.configuration?.title = viewModel.title.title(for: .normal)
        
        switch viewModel.buttonAction {
        case .action(let action):
            self.addAction(
                UIAction(
                    handler: { _ in
                        action()
                        self.isSelected.toggle()
                        if let haptic = viewModel.haptic {
                            haptic.perform()
                        }
                    }
                ),
                for: .touchUpInside
            )
        case .asyncAction(let action):
            self.addAction(
                UIAction(
                    handler: { handler in
                        var handlerButton: GDSButton? = handler.sender as? GDSButton
                        Task { @MainActor in
                            guard let button = handlerButton else { return }
                            let constraint: NSLayoutConstraint? = button.heightAnchor.constraint(equalToConstant: button.bounds.height)
                            constraint?.isActive = true
                            
                            button.isLoading = true
                            await action()
                            button.isSelected.toggle()
                            
                            if let haptic = viewModel.haptic {
                                haptic.perform()
                            }
                            button.isLoading = false
           
                            constraint?.isActive = false
                            handlerButton = nil
                        }
                    }
                ),
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
    
    deinit {
        print("deinit")
    }
}
