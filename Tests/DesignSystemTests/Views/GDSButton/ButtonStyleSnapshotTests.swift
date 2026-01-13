import DesignSystem
import Testing
import UIKit

@MainActor
struct ButtonStyleSnapshotTests {
    let size = CGSize(width: 400, height: 100)
    
    @Test
    func desctructiveButton() {
        let vc = createButton(GDSButtonStyle.destructive, "Destructive")
        vc.assertSnapshot(in: size)
    }
    
    @Test
    func dismissButton() {
        let vc = createButton(GDSButtonStyle.dismiss, "Dismiss")
        vc.assertSnapshot(in: size)
    }
    
    @Test
    func primaryButton() {
        let vc = createButton(GDSButtonStyle.primary, "Primary")
        vc.assertSnapshot(in: size)
    }
    
    @Test
    func secondaryButton() {
        let vc = createButton(GDSButtonStyle.secondary, "Secondary")
        vc.assertSnapshot(in: size)
    }
    
    @Test
    func secondaryDestructiveButton() {
        let vc = createButton(GDSButtonStyle.secondaryDestructive, "Secondary destructive")
        vc.assertSnapshot(in: CGSize(width: 600, height: 100))
    }
    
    func createButton(
        _ style: GDSButtonStyle,
        _ styleName: String
    ) -> UIView {
        let viewModel = GDSButtonViewModel(
            title: "\(styleName)",
            icon: IconStyle.arrowUpRight,
            style: style,
            buttonAction: .action {
                
            },
            horizontalPadding: .horizontal(DesignSystem.Spacing.default)
        )
        
        return viewModel.createUIView()
    }
}
