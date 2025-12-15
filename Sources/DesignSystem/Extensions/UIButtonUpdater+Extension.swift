import UIKit

extension UIButton {
    private func titleWithIcon(viewModel: GDSButtonViewModel) -> AttributedString {
        var attrString = AttributedString(viewModel.title.forState(self.state))
        attrString.font = viewModel.style.font
        attrString.underlineStyle = .single
        
        return attrString.addIcon(
            iconStyle: viewModel.icon?.forState(self.state)
        ) ?? attrString
    }
    
    private func addBorder(viewModel: GDSButtonViewModel) {
        if let borderStyle = viewModel.style.border {
            self.clipsToBounds = true
            self.layer.borderColor = borderStyle.color.cgColor
            self.layer.borderWidth = borderStyle.width
            self.layer.cornerRadius = viewModel.style.cornerRadius
            self.layer.cornerCurve = .continuous
        }
    }
    
    func general(viewModel: GDSButtonViewModel) {
        if let insets = viewModel.style.contentInsets {
            self.configuration?.contentInsets = insets
        }
        
        if (self.configuration?.contentInsets.leading ?? 0) < DesignSystem.Spacing.xSmall,
           UIAccessibility.buttonShapesEnabled || self.state.contains(.focused) {
            self.configuration?.contentInsets.leading = DesignSystem.Spacing.xSmall
            self.configuration?.contentInsets.trailing = DesignSystem.Spacing.xSmall
        }

        self.configuration?.baseForegroundColor = viewModel.style.foregroundColor.forState(self.state)
        self.configuration?.baseBackgroundColor = viewModel.style.backgroundColor.forState(self.state)
        
        self.configuration?.background.cornerRadius = viewModel.style.cornerRadius
        self.configuration?.cornerStyle = .fixed
    
        self.addBorder(viewModel: viewModel)
    }
    
    func buttonShapesEnabled(_ enabled: Bool, viewModel: GDSButtonViewModel) {
        self.configuration?.baseBackgroundColor =
        (enabled &&
         (viewModel.style.backgroundColor.forState(self.state) == UIColor.systemBackground ||
          viewModel.style.backgroundColor.forState(self.state) == UIColor.clear)) ? UIColor(
            light: DesignSystem.Color.Base.grey4,
            dark: DesignSystem.Color.Base.charcoal2
          )
        : viewModel.style.backgroundColor.forState(self.state)
    }
    
    static func buttonUpdater(
        viewModel: GDSButtonViewModel
    ) -> ConfigurationUpdateHandler {
        return { button in
            button.general(viewModel: viewModel)
            
            let title = button.titleWithIcon(viewModel: viewModel)
            
            if let button = button as? GDSButton,
               button.state.contains(.disabled) && button.isLoading {
                button.configuration?.titleAlignment = .center
                button.contentHorizontalAlignment = .center
                button.configuration?.attributedTitle = nil
                button.configuration?.title = nil
                button.configuration?.imagePlacement = .top
                button.accessibilityLabel = "Loading"
                button.accessibilityHint = nil
            } else {
                var string = title
                string.font = viewModel.style.font
                button.configuration?.attributedTitle = string
                button.configuration?.titleAlignment = viewModel.style.alignment
                button.contentHorizontalAlignment = .init(titleAlignment: viewModel.style.alignment)
                button.titleLabel?.textAlignment = .init(titleAlignment: viewModel.style.alignment)
                button.accessibilityLabel = nil
                
                if let icon = viewModel.icon?.forState(button.state),
                   let accessibilityHint = icon.accessibilityHint {
                    button.accessibilityHint = accessibilityHint
                }
                
                button.buttonShapesEnabled(UIAccessibility.buttonShapesEnabled, viewModel: viewModel)
                
                button.configuration?.baseForegroundColor = viewModel.style.foregroundColor.forState(button.state)
            }
        }
    }
}
