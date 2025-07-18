public struct IconStyle: Sendable {
    public let icon: String
    public let position: SymbolPosition
}

extension IconStyle {
    public static let arrowUpRight: Self = IconStyle(icon: "arrow.up.right", position: .afterTitle)
    public static let qrCode: Self = IconStyle(icon: "qrcode", position: .beforeTitle)
}
