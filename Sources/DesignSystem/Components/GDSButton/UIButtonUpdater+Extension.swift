import UIKit

// swiftlint:disable function_body_length
extension UIButton {
    static func buttonUpdater(
        viewModel: GDSButtonViewModel
    ) -> ConfigurationUpdateHandler {
        return { button in

            button.configuration?.titleAlignment = viewModel.style.alignment
            button.contentHorizontalAlignment = viewModel.style.contentAlignment
            
            if let insets = viewModel.style.contentInsets {
                button.configuration?.contentInsets = insets
            }
            
            if (button.configuration?.contentInsets.leading ?? 0) < DesignSystem.Spacing.xSmall,
               UIAccessibility.buttonShapesEnabled {
                button.configuration?.contentInsets.leading = DesignSystem.Spacing.xSmall
            }
            
            var attrString = AttributedString(viewModel.title.normal)
            attrString.font = viewModel.style.font
            let title = attrString.addIcon(
                iconStyle: viewModel.icon
            ) ?? attrString
            
            button.titleLabel?.font = viewModel.style.font
            
            button.configuration?.background.cornerRadius = viewModel.style.cornerRadius
            button.configuration?.cornerStyle = .fixed
            
            if let borderStyle = viewModel.style.border {
                button.clipsToBounds = true
                button.layer.borderColor = borderStyle.color.cgColor
                button.layer.borderWidth = borderStyle.width
                button.layer.cornerRadius = viewModel.style.cornerRadius
                button.layer.cornerCurve = .continuous
            }
            
            switch viewModel.style.alignment {
            case .leading:
                button.titleLabel?.textAlignment = .left
            case .trailing:
                button.titleLabel?.textAlignment = .right
            default:
                button.titleLabel?.textAlignment = .center
            }

            switch button.state {
            case [.selected, .highlighted]:
                var string = title
                string.font = viewModel.style.font
                button.configuration?.attributedTitle = string
                
                if let color = viewModel.style.backgroundColor.selectedHighlighted {
                    button.configuration?.baseBackgroundColor = color
                }
                
                if let color = viewModel.style.foregroundColor.selectedHighlighted {
                    button.configuration?.baseForegroundColor = color
                }

            case [.focused, .highlighted]:
                var string = title
                string.font = viewModel.style.font
                button.configuration?.attributedTitle = string
                
                if (button.configuration?.contentInsets.leading ?? 0) < DesignSystem.Spacing.xSmall {
                    button.configuration?.contentInsets.leading = DesignSystem.Spacing.xSmall
                }
                
                if let color = viewModel.style.backgroundColor.focusedHighlighted {
                    button.configuration?.baseBackgroundColor = color
                }
                
                if let color = viewModel.style.foregroundColor.focusedHighlighted {
                    button.configuration?.baseForegroundColor = color
                }
                
            case .selected:
                var string = title
                string.font = viewModel.style.font
                button.configuration?.attributedTitle = string
                
                if let color = viewModel.style.backgroundColor.selected {
                    button.configuration?.baseBackgroundColor = color
                }
                
                if let color = viewModel.style.foregroundColor.selected {
                    button.configuration?.baseForegroundColor = color
                }
                
            case .highlighted:
                var string = title
                string.font = viewModel.style.font
                button.configuration?.attributedTitle = string

                if let color = viewModel.style.backgroundColor.highlighted {
                    button.configuration?.baseBackgroundColor = color
                }
                
                if let color = viewModel.style.foregroundColor.highlighted {
                    button.configuration?.baseForegroundColor = color
                }
                
            case .focused:
                var string = title
                string.font = viewModel.style.font
                button.configuration?.attributedTitle = string
                
                if (button.configuration?.contentInsets.leading ?? 0) < DesignSystem.Spacing.xSmall {
                    button.configuration?.contentInsets.leading = DesignSystem.Spacing.xSmall
                }
                
                if let color = viewModel.style.backgroundColor.focused {
                    button.configuration?.baseBackgroundColor = color
                }
                
                if let color = viewModel.style.foregroundColor.focused {
                    button.configuration?.baseForegroundColor = color
                }
                
            case .disabled, [.focused, .disabled]:
                button.configuration?.attributedTitle = nil
                button.configuration?.title = nil

                if let color = viewModel.style.backgroundColor.disabled {
                    button.configuration?.baseBackgroundColor = color
                }
                
                if let color = viewModel.style.foregroundColor.disabled {
                    button.configuration?.baseForegroundColor = color
                }
                
            default:
                var string = title
                string.font = viewModel.style.font
                button.configuration?.attributedTitle = string
                
                if viewModel.style.backgroundColor.normal == UIColor.systemBackground
                && UIAccessibility.buttonShapesEnabled {
                    button.configuration?.baseBackgroundColor = .systemGray6
                } else {
                    button.configuration?.baseBackgroundColor = viewModel.style.backgroundColor.normal
                }
                button.configuration?.baseForegroundColor = viewModel.style.foregroundColor.normal
            }
        }
    }
}
// swiftlint:enable function_body_length
