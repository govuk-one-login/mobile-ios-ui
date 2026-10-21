import UIKit

extension UIButton {
    private func titleWithIcon(viewModel: GDSButtonViewModel) -> AttributedString {
        var attrString = AttributedString(viewModel.title.forState(self.state))
        attrString.font = viewModel.style.font
        
        if UIAccessibility.buttonShapesEnabled {
            attrString.uiKit.underlineStyle = .single
        }
        
        return attrString.addIcon(
            iconStyle: viewModel.icon?.forState(self.state)
        ) ?? attrString
    }
    
    private func addBorder(viewModel: GDSButtonViewModel) {
        if let borderStyle = viewModel.style.border {
            self.clipsToBounds = true
            self.layer.borderColor = borderStyle.color.cgColor
            self.layer.borderWidth = borderStyle.width
            if let cornerRadius = viewModel.style.cornerRadius {
                self.configuration?.background.cornerRadius = cornerRadius
            }
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
        self.configuration?.background.backgroundColor = viewModel.style.backgroundColor.forState(self.state)
        
        self.configuration?.cornerStyle = viewModel.style.cornerStyle
        if let cornerRadius = viewModel.style.cornerRadius {
            self.configuration?.background.cornerRadius = cornerRadius
        }
    
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
                button.configuration?.titleAlignment = button.viewModel.style.alignment
                button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment(alignment: button.viewModel.style.alignment)
                button.configuration?.attributedTitle = nil
                button.configuration?.title = button.viewModel.title.loading
                button.configuration?.showsActivityIndicator = true
                button.configuration?.imagePlacement = .horizontal
                button.configuration?.imagePlacement = .leading
                button.configuration?.imagePadding = DesignSystem.Spacing.small
                button.accessibilityLabel = button.viewModel.title.loading ?? "Loading"
                button.accessibilityHint = nil
                button.setTitleColor(viewModel.style.foregroundColor.loading, for: .disabled)
            } else {
                var string = title
                string.font = viewModel.style.font
                string.foregroundColor = viewModel.style.foregroundColor.forState(button.state)
                button.configuration?.attributedTitle = string
                button.configuration?.titleAlignment = viewModel.style.alignment
                button.contentHorizontalAlignment = .init(titleAlignment: viewModel.style.alignment)
                button.titleLabel?.textAlignment = .init(titleAlignment: viewModel.style.alignment)
                button.accessibilityLabel = nil
                
                if let accessibilityHint = viewModel.accessibilityHint {
                    button.accessibilityHint = accessibilityHint
                }
                
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

extension UIControl.ContentHorizontalAlignment {
    init(alignment: UIButton.Configuration.TitleAlignment) {
        switch alignment {
        case .automatic:
            self.init(titleAlignment: .automatic)
        case .leading:
            self.init(titleAlignment: .leading)
        case .center:
            self.init(titleAlignment: .center)
        case .trailing:
            self.init(titleAlignment: .trailing)
        @unknown default:
            self.init(titleAlignment: .center)
        }
    }
}
