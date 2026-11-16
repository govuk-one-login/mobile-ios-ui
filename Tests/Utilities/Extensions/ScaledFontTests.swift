@testable import DesignSystem
import SwiftUI
import Testing
import UIKit

struct ScaledFontTests {
    // MARK: - Scaling

    @Test("Resolving at the default .large size reproduces the native preferred size")
    func resolve_defaultSize_matchesNativeBaseline() {
        // SwiftUI's default dynamic type size is `.large`, and its native
        // text-style fonts anchor to the UIKit `.large` category. Resolving a
        // token at `.large` must therefore equal UIKit's own preferred font at
        // `.large` — this guards the 1pt baseline drift the AgeBadge regression
        // exposed.
        let token = DesignSystem.Font.Base.footnoteBold

        let resolved = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .large)

        let reference = UIFont.preferredFont(
            forTextStyle: .footnote,
            compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)
        )
        #expect(resolved.pointSize == reference.pointSize)
    }

    @Test("Resolving matches UIKit's preferred font for the text style and size")
    func resolve_matchesPreferredFontForSize() {
        let token = DesignSystem.Font.Base.body

        let resolved = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .xxLarge)

        let reference = UIFont.preferredFont(
            forTextStyle: .body,
            compatibleWith: UITraitCollection(preferredContentSizeCategory: .extraExtraLarge)
        )
        #expect(resolved.pointSize == reference.pointSize)
    }

    @Test("A larger dynamic type size produces a larger point size")
    func resolve_largerSize_scalesUp() {
        let token = DesignSystem.Font.Base.body

        let small = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .small)
        let accessibility = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .accessibility5)

        #expect(accessibility.pointSize > small.pointSize)
    }

    @Test("A smaller dynamic type size produces a smaller point size")
    func resolve_smallerSize_scalesDown() {
        let token = DesignSystem.Font.Base.body

        let large = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .large)
        let extraSmall = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .xSmall)

        #expect(extraSmall.pointSize < large.pointSize)
    }

    @Test("Scaling is applied exactly once (not double-scaled)")
    func resolve_doesNotDoubleScale() {
        // A body token at accessibility2 (accessibilityLarge) should match UIKit's
        // own preferred body font for that category. Double-scaling (the bug this
        // guards) would make it noticeably larger than the reference.
        let token = DesignSystem.Font.Base.body

        let resolved = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .accessibility2)

        let reference = UIFont.preferredFont(
            forTextStyle: .body,
            compatibleWith: UITraitCollection(preferredContentSizeCategory: .accessibilityLarge)
        )
        #expect(resolved.pointSize == reference.pointSize)
    }

    // MARK: - Weight preservation

    @Test("Bold weight is preserved when scaling")
    func resolve_preservesBoldWeight() {
        let token = DesignSystem.Font.Base.largeTitleBold

        let resolved = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .accessibility2)

        #expect(resolved.fontDescriptor.symbolicTraits.contains(.traitBold))
    }

    // MARK: - Design preservation (the monospaced regression guard)

    @Test("Monospaced design is preserved when scaling")
    func resolve_preservesMonospacedDesign() {
        let token = DesignSystem.Font.Base.bodyBoldMonospaced

        let resolved = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .accessibility2)

        // Regression guard: re-resolving must keep the monospaced family, not fall
        // back to the proportional system font. SF Mono's family name contains
        // "Monospaced".
        #expect(resolved.familyName.contains("Monospaced"))
        // ...and it must still be bold.
        #expect(resolved.fontDescriptor.symbolicTraits.contains(.traitBold))
    }

    @Test("Monospaced bold design and weight both survive when scaled")
    func resolve_monospacedBold_matchesPreferredSize() {
        let token = DesignSystem.Font.Base.bodyBoldMonospaced

        let resolved = ScaledFont.resolve(uiFont: token, dynamicTypeSize: .xxLarge)

        #expect(resolved.familyName.contains("Monospaced"))
        #expect(resolved.fontDescriptor.symbolicTraits.contains(.traitBold))
        // Size scales exactly once: equal to the body preferred size at that category.
        let reference = UIFont.preferredFont(
            forTextStyle: .body,
            compatibleWith: UITraitCollection(preferredContentSizeCategory: .extraExtraLarge)
        )
        #expect(resolved.pointSize == reference.pointSize)
    }

    // MARK: - Design detection

    @Test("design(of:) detects monospaced tokens")
    func design_detectsMonospaced() {
        #expect(ScaledFont.design(of: DesignSystem.Font.Base.bodyBoldMonospaced) == .monospaced)
    }

    @Test("design(of:) returns nil for a plain proportional token")
    func design_nilForProportional() {
        #expect(ScaledFont.design(of: DesignSystem.Font.Base.body) == nil)
    }

    // MARK: - Weight detection

    @Test("weight(of:) reads the token's bold weight")
    func weight_readsBold() {
        #expect(ScaledFont.weight(of: DesignSystem.Font.Base.largeTitleBold) == .bold)
    }

    // MARK: - DynamicTypeSize mapping

    @Test("DynamicTypeSize maps to the matching UIContentSizeCategory", arguments: [
        (DynamicTypeSize.xSmall, UIContentSizeCategory.extraSmall),
        (.small, .small),
        (.medium, .medium),
        (.large, .large),
        (.xLarge, .extraLarge),
        (.xxLarge, .extraExtraLarge),
        (.xxxLarge, .extraExtraExtraLarge),
        (.accessibility1, .accessibilityMedium),
        (.accessibility2, .accessibilityLarge),
        (.accessibility3, .accessibilityExtraLarge),
        (.accessibility4, .accessibilityExtraExtraLarge),
        (.accessibility5, .accessibilityExtraExtraExtraLarge)
    ])
    func uiContentSizeCategory_mapping(
        dynamicTypeSize: DynamicTypeSize,
        expected: UIContentSizeCategory
    ) {
        #expect(UIContentSizeCategory(dynamicTypeSize) == expected)
    }
}
