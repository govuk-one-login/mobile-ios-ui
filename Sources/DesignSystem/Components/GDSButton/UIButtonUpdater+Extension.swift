import UIKit

extension UIButton {
    func general(viewModel: GDSButtonViewModel) -> AttributedString {
        if let insets = viewModel.style.contentInsets {
            self.configuration?.contentInsets = insets
        }
        
        if (self.configuration?.contentInsets.leading ?? 0) < DesignSystem.Spacing.xSmall,
           UIAccessibility.buttonShapesEnabled {
            self.configuration?.contentInsets.leading = DesignSystem.Spacing.xSmall
        }
        
        var attrString = AttributedString(viewModel.title.title(for: self.state))
        attrString.font = viewModel.style.font
        let title = attrString.addIcon(
            iconStyle: viewModel.icon?.icon(for: self.state)
        ) ?? attrString
        
        self.titleLabel?.font = viewModel.style.font
        
        self.configuration?.background.cornerRadius = viewModel.style.cornerRadius
        self.configuration?.cornerStyle = .fixed
        
        if let borderStyle = viewModel.style.border {
            self.clipsToBounds = true
            self.layer.borderColor = borderStyle.color.cgColor
            self.layer.borderWidth = borderStyle.width
            self.layer.cornerRadius = viewModel.style.cornerRadius
            self.layer.cornerCurve = .continuous
        }
        
        self.configuration?.baseBackgroundColor = viewModel.style.backgroundColor.color(for: self.state)
        
        self.configuration?.baseForegroundColor = viewModel.style.foregroundColor.color(for: self.state)
        
        return title
    }
    
    static func buttonUpdater(
        viewModel: GDSButtonViewModel
    ) -> ConfigurationUpdateHandler {
        return { button in
            
            let title = button.general(viewModel: viewModel)
            
            if button.state.contains(.disabled) {
                button.configuration?.titleAlignment = .center
                button.contentHorizontalAlignment = .center
                button.configuration?.attributedTitle = nil
                button.configuration?.title = nil
                button.configuration?.imagePlacement = .top
            } else {
                button.configuration?.titleAlignment = viewModel.style.alignment
                button.contentHorizontalAlignment = viewModel.style.contentAlignment
                
                var string = title + " " + AttributedString(button.state.description)
                string.font = viewModel.style.font
                button.configuration?.attributedTitle = string
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

// for debug
extension UIButton.State: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case [.selected, .highlighted]:
            return "selectedHighlighted"
        case [.focused, .highlighted]:
            return "focusedHighlighted"
        case .focused:
            return "focused"
        case .highlighted:
            return "highlighted"
        case .selected:
            return "selected"
        case .disabled, [.focused, .disabled]:
            return "disabled"
        case .normal:
            return "normal"
        default:
            return "default"
        }
    }
}
