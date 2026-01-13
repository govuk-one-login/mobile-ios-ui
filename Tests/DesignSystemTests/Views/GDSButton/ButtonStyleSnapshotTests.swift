import DesignSystem
import Testing
import UIKit

@MainActor
struct ButtonStyleSnapshotTests {
    let size = CGSize(width: 400, height: 100)
    
    @Test
    func desctructiveButton() {
        if let vc = createButton(
            GDSButtonStyle.destructive,
            "Destructive"
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func desctructiveButtonHighlighted() {
        if let vc = createButton(
            GDSButtonStyle.destructive,
            "Destructive",
            highlighted: true
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func desctructiveButtonDisabled() {
        if let vc = createButton(
            GDSButtonStyle.destructive,
            "Destructive",
            enabled: false
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func dismissButton() {
        if let vc = createButton(
            GDSButtonStyle.dismiss,
            "Dismiss"
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func dismissButtonHighlighted() {
        if let vc = createButton(
            GDSButtonStyle.dismiss,
            "Dismiss",
            highlighted: true
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func dismissButtonDisabled() {
        if let vc = createButton(
            GDSButtonStyle.dismiss,
            "Dismiss",
            enabled: false
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func primaryButton() {
        if let vc = createButton(
            GDSButtonStyle.primary,
            "Primary"
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func primaryButtonHighlighted() {
        if let vc = createButton(
            GDSButtonStyle.primary,
            "Primary",
            highlighted: true
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func primaryButtonDisabled() {
        if let vc = createButton(
            GDSButtonStyle.primary,
            "Primary",
            enabled: false
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func secondaryButton() {
        if let vc = createButton(
            GDSButtonStyle.secondary,
            "Secondary"
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func secondaryButtonHighlighted() {
        if let vc = createButton(
            GDSButtonStyle.secondary,
            "Secondary",
            highlighted: true
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func secondaryButtonDisabled() {
        if let vc = createButton(
            GDSButtonStyle.secondary,
            "Secondary",
            enabled: false
        ) {
            vc.assertSnapshot(in: size)
        }
    }
    
    @Test
    func secondaryDestructiveButton() {
        if let vc = createButton(
            GDSButtonStyle.secondaryDestructive,
            "Secondary destructive"
        ) {
            vc.assertSnapshot(in: CGSize(width: 600, height: 100))
        }
    }
    
    @Test
    func secondaryDestructiveButtonHighlighted() {
        if let vc = createButton(
            GDSButtonStyle.secondaryDestructive,
            "Secondary destructive",
            highlighted: true
        ) {
            vc.assertSnapshot(in: CGSize(width: 600, height: 100))
        }
    }
    
    @Test
    func secondaryDestructiveButtonDisabled() {
        if let vc = createButton(
            GDSButtonStyle.secondaryDestructive,
            "Secondary destructive",
            enabled: false
        ) {
            vc.assertSnapshot(in: CGSize(width: 600, height: 100))
        }
    }
    
    func createButton(
        _ style: GDSButtonStyle,
        _ styleName: String,
        highlighted: Bool = false,
        enabled: Bool = true
    ) -> UIView? {
        let viewModel = GDSButtonViewModel(
            title: "\(styleName)",
            icon: IconStyle.arrowUpRight,
            style: style,
            buttonAction: .action {
                
            },
            horizontalPadding: .horizontal(DesignSystem.Spacing.default)
        )
        
        let button = viewModel.createUIView() as? UIButton
        button?.isHighlighted = highlighted
        button?.isEnabled = enabled
        return button
    }
}
