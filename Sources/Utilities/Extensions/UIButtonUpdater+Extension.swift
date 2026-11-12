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
    
    func addBorder(
        viewModel: GDSButtonViewModel,
        setLayerCornerRadius: Bool = false
    ) {
        if let borderStyle = viewModel.style.border {
            self.clipsToBounds = true
            self.layer.borderColor = borderStyle.color.cgColor
            self.layer.borderWidth = borderStyle.width
            if let cornerRadius = viewModel.style.cornerRadius {
                self.configuration?.background.cornerRadius = cornerRadius
                
                if setLayerCornerRadius {
                    // The border is drawn on `self.layer`, so the layer's own corner radius must
                    // be set too. Prior to iOS 26 the configuration background does not drive the
                    // layer corners, so without this the rounded border would render as square.
                    self.layer.cornerRadius = cornerRadius
                }
            }
            self.layer.cornerCurve = .continuous
        }
    }
    
    func general(viewModel: GDSButtonViewModel) {
        if let insets = viewModel.style.contentInsets {
            self.configuration?.contentInsets = insets
        }

        self.configuration?.baseForegroundColor = viewModel.style.foregroundColor.forState(self.state)
        self.configuration?.baseBackgroundColor = viewModel.style.backgroundColor.forState(self.state)
        self.configuration?.background.backgroundColor = viewModel.style.backgroundColor.forState(self.state)
        
        self.configuration?.cornerStyle = viewModel.style.cornerStyle
        if let cornerRadius = viewModel.style.cornerRadius {
            self.configuration?.background.cornerRadius = cornerRadius
        }
    
        var setLayerCornerRadius: Bool = false
        if #unavailable(iOS 26) {
            setLayerCornerRadius = true
        }
        
        self.addBorder(
            viewModel: viewModel,
            setLayerCornerRadius: setLayerCornerRadius
        )
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
            
            // Alignment is state-independent: both the loading and non-loading
            // paths apply the same value, so it is set once up front. If a future
            // state ever needs a different alignment, reassign it within that branch.
            button.configuration?.titleAlignment = viewModel.style.alignment
            button.contentHorizontalAlignment = .init(titleAlignment: viewModel.style.alignment)
            
            // State-aware foreground transformer. `borderedProminent()` installs a
            // default transformer that re-dims content to the system disabled colour
            // at render time. Because loading is tied to `.disabled`, that dimming
            // overrides the explicit loading colour resolved from `ColorForState`.
            // This transformer forces the explicit loading colour when `.loading` is
            // present, and otherwise returns the incoming attributes untouched so the
            // system's free disabled dimming is preserved for genuine disabled buttons.
            button.configuration?.titleTextAttributesTransformer =
                UIConfigurationTextAttributesTransformer { [weak button] incoming in
                    guard let button, button.state.contains(.loading) else { return incoming }
                    var outgoing = incoming
                    outgoing.foregroundColor = viewModel.style.foregroundColor.forState(button.state)
                    return outgoing
                }
            
            if #available(iOS 16.0, *) {
                button.configuration?.activityIndicatorColorTransformer =
                    UIConfigurationColorTransformer { [weak button] incoming in
                        guard let button, button.state.contains(.loading) else { return incoming }
                        return viewModel.style.foregroundColor.forState(button.state)
                    }
            }
            
            if button.state.contains(.loading) {
                button.configuration?.attributedTitle = nil
                // `button.state` contains `.loading`, so these resolvers return the
                // loading value (falling back to normal when none is configured).
                button.configuration?.title = viewModel.title.forState(button.state)
                button.configuration?.showsActivityIndicator = true
                button.configuration?.imagePlacement = .leading
                button.configuration?.imagePadding = DesignSystem.Spacing.small
                button.accessibilityLabel = viewModel.title.loading ?? "Loading"
                button.accessibilityHint = nil
            } else {
                var attributedString = button.titleWithIcon(viewModel: viewModel)
                attributedString.font = viewModel.style.font
                attributedString.foregroundColor = viewModel.style.foregroundColor.forState(button.state)
                button.configuration?.attributedTitle = attributedString
                button.titleLabel?.textAlignment = .init(titleAlignment: viewModel.style.alignment)
                button.accessibilityLabel = nil
                
                if let accessibilityHint = viewModel.accessibilityHint {
                    button.accessibilityHint = accessibilityHint
                }
                
                if let accessibilityLabel = viewModel.accessibilityLabel {
                    button.accessibilityLabel = accessibilityLabel
                }
                
                if let icon = viewModel.icon?.forState(button.state),
                   let accessibilityHint = icon.accessibilityHint {
                    button.accessibilityHint = accessibilityHint
                }
                
                button.buttonShapesEnabled(UIAccessibility.buttonShapesEnabled, viewModel: viewModel)
                
                button.configuration?.baseForegroundColor = viewModel.style.foregroundColor.forState(button.state)
                
                button.maximumContentSizeCategory = viewModel.maxContentSizeCategory
                button.titleLabel?.maximumContentSizeCategory = viewModel.maxContentSizeCategory
            }
        }
    }
}
