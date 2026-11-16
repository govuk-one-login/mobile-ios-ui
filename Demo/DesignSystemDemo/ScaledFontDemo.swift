import DesignSystem
import SwiftUI
import UIKit

/// Demonstrates `.scaledFont(_:)`, which applies a DesignSystem `UIFont` token
/// as a SwiftUI font that scales with Dynamic Type.
///
/// Change the text size in Settings > Accessibility > Display & Text Size >
/// Larger Text (or use the Xcode environment overrides) to compare the rows.
enum ScaledFontDemo {
    @MainActor
    static func makeScreen() -> UIViewController {
        let controller = UIHostingController(rootView: ScaledFontDemoView())
        controller.title = "Scaled Font"
        return controller
    }
}

private struct ScaledFontDemoView: View {
    var body: some View {
        List {
            Section {
                Text("Title 1 bold")
                    .scaledFont(DesignSystem.Font.Base.title1Bold)
                Text("Body")
                    .scaledFont(DesignSystem.Font.Base.body)
                Text("Body bold")
                    .scaledFont(DesignSystem.Font.Base.bodyBold)
                Text("12:34:56 monospaced")
                    .scaledFont(DesignSystem.Font.Base.bodyBoldMonospaced)
                Text("Footnote bold")
                    .scaledFont(DesignSystem.Font.Base.footnoteBold)
            } header: {
                Text("Scales with Dynamic Type: .scaledFont(_:)")
            }

            Section {
                Text("Body")
                    .font(Font(DesignSystem.Font.Base.body))
                Text("Body bold")
                    .font(Font(DesignSystem.Font.Base.bodyBold))
            } header: {
                Text("Fixed size: .font(Font(uiFont))")
            } footer: {
                Text("These stay at a fixed point size when the text size changes.")
            }
        }
    }
}
