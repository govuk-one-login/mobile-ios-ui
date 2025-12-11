import DesignSystem
import UIKit

extension String {
    func getWelshString(for bundle: Bundle = .designSystem) -> String {
        NSLocalizedString(
            key: self,
            tableName: "cy.lproj/Localizable",
            bundle: bundle,
            comment: ""
        )
    }
}
