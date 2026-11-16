import SwiftUI
import UIKit

/// Resolves a DesignSystem `UIFont` token to a font scaled for a given Dynamic
/// Type size. Pure, so it can be unit tested directly.
enum ScaledFont {
    /// Re-resolves `uiFont` at `dynamicTypeSize`, preserving weight and design.
    ///
    /// Tokens are already scaled to the process's size category, so passing them
    /// through `UIFontMetrics` would double-scale. Instead this re-resolves the
    /// preferred font for the token's text style, then re-applies its traits and
    /// design.
    static func resolve(
        uiFont: UIFont,
        dynamicTypeSize: DynamicTypeSize
    ) -> UIFont {
        let traits = UITraitCollection(
            preferredContentSizeCategory: UIContentSizeCategory(dynamicTypeSize)
        )

        guard let textStyleRaw = uiFont.fontDescriptor
            .object(forKey: .textStyle) as? String else {
            // Not a text-style font (shouldn't happen for DesignSystem tokens);
            // fall back to the token as-is.
            return uiFont
        }

        let textStyle = UIFont.TextStyle(rawValue: textStyleRaw)
        var descriptor = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: textStyle,
            compatibleWith: traits
        )

        // Re-apply symbolic traits (e.g. bold / italic).
        if let withTraits = descriptor.withSymbolicTraits(uiFont.fontDescriptor.symbolicTraits) {
            descriptor = withTraits
        }

        // Re-apply the design (e.g. monospaced), which symbolic traits don't carry.
        // Weight is set first because `withDesign` can otherwise reset it.
        if let design = design(of: uiFont),
           let withDesign = descriptor
           .addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight(of: uiFont)]])
           .withDesign(design) {
            descriptor = withDesign
        }

        // size: 0 keeps the (correctly scaled) size from the preferred descriptor.
        return UIFont(descriptor: descriptor, size: 0)
    }

    /// The font's system design (e.g. `.monospaced`), detected from its family name.
    static func design(of uiFont: UIFont) -> UIFontDescriptor.SystemDesign? {
        let family = uiFont.familyName
        if family.contains("Monospaced") {
            return .monospaced
        }
        if family.contains("Rounded") {
            return .rounded
        }
        if family.contains("Serif") {
            return .serif
        }
        return nil
    }

    /// The font's weight, read from its traits.
    static func weight(of uiFont: UIFont) -> UIFont.Weight {
        guard let traits = uiFont.fontDescriptor
            .object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any],
            let raw = traits[.weight] as? CGFloat else {
            return uiFont.fontDescriptor.symbolicTraits.contains(.traitBold) ? .bold : .regular
        }
        return UIFont.Weight(rawValue: raw)
    }
}

/// Bridges a DesignSystem `UIFont` token into a SwiftUI `Font` that scales with
/// Dynamic Type.
///
/// `Font(_: UIFont)` alone pins the font at a fixed size. Reading the environment
/// makes the font recompute via ``ScaledFont`` when the text size changes.
private struct ScaledFontModifier: ViewModifier {
    /// Makes the modifier reactive to text size changes.
    ///
    /// Preferred over `sizeCategory`, which isn't reliably populated from the
    /// active `UITraitCollection` (e.g. in snapshot tests) and resolved one step
    /// below the `.large` baseline.
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let uiFont: UIFont

    func body(content: Content) -> some View {
        content.font(Font(ScaledFont.resolve(uiFont: uiFont, dynamicTypeSize: dynamicTypeSize)))
    }
}

extension View {
    /// Applies a DesignSystem `UIFont` token as a font that scales with Dynamic
    /// Type. Use in place of `.font(Font(someUIFont))`.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .scaledFont(DesignSystem.Font.Base.bodyBold)
    /// ```
    public func scaledFont(_ uiFont: UIFont) -> some View {
        modifier(ScaledFontModifier(uiFont: uiFont))
    }
}

extension UIContentSizeCategory {
    /// Maps SwiftUI's `DynamicTypeSize` to the equivalent `UIContentSizeCategory`.
    init(_ dynamicTypeSize: DynamicTypeSize) {
        switch dynamicTypeSize {
        case .xSmall: self = .extraSmall
        case .small: self = .small
        case .medium: self = .medium
        case .large: self = .large
        case .xLarge: self = .extraLarge
        case .xxLarge: self = .extraExtraLarge
        case .xxxLarge: self = .extraExtraExtraLarge
        case .accessibility1: self = .accessibilityMedium
        case .accessibility2: self = .accessibilityLarge
        case .accessibility3: self = .accessibilityExtraLarge
        case .accessibility4: self = .accessibilityExtraExtraLarge
        case .accessibility5: self = .accessibilityExtraExtraExtraLarge
        @unknown default: self = .large
        }
    }
}
