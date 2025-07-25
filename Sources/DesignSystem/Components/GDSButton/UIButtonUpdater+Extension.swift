import UIKit

extension UIButton {
    private func titleWithIcon(viewModel: GDSButtonViewModel) -> AttributedString {
        var attrString = AttributedString(viewModel.title.title(for: self.state))
        attrString.font = viewModel.style.font
        return attrString.addIcon(
            iconStyle: viewModel.icon?.icon(for: self.state)
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
           UIAccessibility.buttonShapesEnabled {
            self.configuration?.contentInsets.leading = DesignSystem.Spacing.xSmall
        }

        self.configuration?.baseForegroundColor = viewModel.style.foregroundColor.color(for: self.state)
        
        self.configuration?.baseBackgroundColor = viewModel.style.backgroundColor.color(for: self.state)
        self.configuration?.background.cornerRadius = viewModel.style.cornerRadius
        self.configuration?.cornerStyle = .fixed
    
        self.addBorder(viewModel: viewModel)
    }
    
    static func buttonUpdater(
        viewModel: GDSButtonViewModel
    ) -> ConfigurationUpdateHandler {
        return { button in
            
            button.general(viewModel: viewModel)
            
            let title = button.titleWithIcon(viewModel: viewModel)
            
            if button.state.contains(.disabled) {
                button.configuration?.titleAlignment = .center
                button.contentHorizontalAlignment = .center
                button.configuration?.attributedTitle = nil
                button.configuration?.title = nil
                button.configuration?.imagePlacement = .top
            } else {
                var string = title
                string.font = viewModel.style.font
                button.configuration?.attributedTitle = string
                
                button.configuration?.titleAlignment = viewModel.style.alignment
                button.contentHorizontalAlignment = .init(titleAlignment: viewModel.style.alignment)
                button.titleLabel?.textAlignment = .init(titleAlignment: viewModel.style.alignment)
            }
            
            if button.state.contains(.focused) &&
                (button.configuration?.contentInsets.leading ?? 0) < DesignSystem.Spacing.xSmall {
                button.configuration?.contentInsets.leading = DesignSystem.Spacing.xSmall
            }
            
            switch button.state {
            case .normal:
                if viewModel.style.backgroundColor.color(for: button.state) == UIColor.systemBackground
                    && UIAccessibility.buttonShapesEnabled {
                    button.configuration?.baseBackgroundColor = .systemGray6
                } else {
                    button.configuration?.baseBackgroundColor = viewModel.style.backgroundColor.color(for: button.state)
                }
                button.configuration?.baseForegroundColor = viewModel.style.foregroundColor.color(for: button.state)
                
            default:
                button.configuration?.baseBackgroundColor = viewModel.style.backgroundColor.color(for: button.state)
                
                button.configuration?.baseForegroundColor = viewModel.style.foregroundColor.color(for: button.state)
                
            }
        }
    }
}
