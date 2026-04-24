import UIKit

@available(*, deprecated, renamed: "GDSDividerView", message: "to be removed October 2025")
public typealias GDSCardDividerView = GDSDividerView

public final class GDSDividerView: UIView, ContentView {
    public init(viewModel: GDSDividerViewModel) {
        super.init(frame: .zero)
        
        self.backgroundColor = viewModel.colour
        let scale = 1 / UIScreen.main.scale
        self.heightAnchor.constraint(equalToConstant: (viewModel.height * scale)).isActive = true
        self.accessibilityIdentifier = "gds-divider-view"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
