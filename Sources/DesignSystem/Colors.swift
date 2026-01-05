import UIKit

// As per Color defined in Figma design system:
extension DesignSystem {
    public enum Color {
        
        public enum Backgrounds {
            public static let card = UIColor(
                light: Color.Base.white,
                dark: Color.Base.charcoal1
            )
            
            public static let statusOverlay = Color.Base.grey1
            public static let qrScanner = Color.Base.black2Alpha70
        }
        
        public enum Dividers {
            public static let `default` = UIColor(
                light: Color.Base.grey2,
                dark: Color.Base.white
            )
            
            public static let card = UIColor(
                light: Color.Base.grey1,
                dark: Color.Base.grey3
            )
        }
        
        public enum Borders {}
        
        public enum Gradients {}
        
        public enum Text {
            public static let primary = UIColor(
                light: Color.Base.black1,
                dark: Color.Base.white
            )
            
            public static let secondary = UIColor(
                light: Color.Base.grey1,
                dark: Color.Base.white
            )
            
            public static let statusOverlay = Color.Base.white
            public static let qrScanner = Color.Base.white
        }
        
        public enum Links {
            public static let `default` = UIColor(
                light: Color.Base.green1,
                dark: Color.Base.green3
            )
        }
        
        public enum Buttons {
            public static let primaryForeground = Color.Base.white
            public static let primaryForegroundFocused = Color.Base.black1
            public static let primaryForegroundDisabled = Color.Base.charcoal1
            public static let primaryBackground = UIColor(
                light: Color.Base.green1,
                dark: Color.Base.green2
            )
            public static let primaryBackgroundHighlighted = UIColor(
                light: Color.Base.green8,
                dark: Color.Base.green7
            )
            public static let primaryBackgroundFocused = Color.Base.yellow1
            public static let primaryBackgroundFocusedHighlighted = Color.Base.yellow4
            public static let primaryBackgroundDisabled = Color.Base.grey3
            
            public static let secondaryForeground = UIColor(
                light: Color.Base.green1,
                dark: Color.Base.green3
            )
            public static let secondaryForegroundFocused = Color.Base.black1
            public static let secondaryForegroundHighlighted = UIColor(
                light: Color.Base.green8,
                dark: Color.Base.green6
            )
            public static let secondaryBackgroundFocused = Color.Base.yellow1
            public static let secondaryBackgroundFocusedHighlighted = Color.Base.yellow4

            public static let destructiveForeground = Color.Base.white
            public static let destructiveForegroundFocused = Color.Base.black1
            public static let destructiveForegroundDisabled = Color.Base.charcoal1
            public static let destructiveBackground = Color.Base.red1
            public static let destructiveBackgroundFocused = Color.Base.yellow1
            public static let destructiveBackgroundHighlighted = Color.Base.red4
            public static let destructiveBackgroundFocusedHighlighted = Color.Base.yellow4
            public static let destructiveBackgroundDisabled = Color.Base.grey3
            
            public static let nativeButtonText = UIColor(
                light: Color.Base.green1,
                dark: Color.Base.green3
            )
            public static let nativeButtonTextDestructive = UIColor(
                light: Color.Base.red1,
                dark: Color.Base.red2
            )
        }
        
        public enum Icons {
            public static let `default` = UIColor(
                light: Color.Base.black1,
                dark: Color.Base.white
            )
            
            public static let success = UIColor(
                light: Color.Base.green1,
                dark: Color.Base.green2
            )
            
            public static let error = UIColor(
                light: Color.Base.black1,
                dark: Color.Base.white
            )
            
            public static let destructive = Color.Base.red1
            public static let statusOverlay = Color.Base.white
        }
        
        public enum NavigationElements {
            public static let navigationBarElements = UIColor(
                light: Color.Base.green1,
                dark: Color.Base.green3
            )
            
            public static let selectedTabIconAndLabel = UIColor(
                light: Color.Base.green1,
                dark: Color.Base.green3
            )
        }
        
        public enum Radios {
            public static let selectedIcon = UIColor(
                light: Color.Base.green1,
                dark: Color.Base.green3
            )
        }
        
        public enum Shadows {
            public static let card = Color.Base.black2Alpha15
        }
        
        public enum Base {
            public static let black1 = UIColor.fromHex("#0B0C0C")
            
            public static let black2 = UIColor.fromHex("#000000")
            public static let black2Alpha5 = black2.withAlphaComponent(0.05)
            public static let black2Alpha12 = black2.withAlphaComponent(0.12)
            public static let black2Alpha15 = black2.withAlphaComponent(0.15)
            public static let black2Alpha20 = black2.withAlphaComponent(0.2)
            public static let black2Alpha30 = black2.withAlphaComponent(0.3)
            public static let black2Alpha50 = black2.withAlphaComponent(0.5)
            public static let black2Alpha70 = black2.withAlphaComponent(0.7)
            
            public static let charcoal1 = UIColor.fromHex("#262626")
            public static let charcoal2 = UIColor.fromHex("#3C3C3C")
            
            public static let green1 = UIColor.fromHex("#00703C")
            public static let green2 = UIColor.fromHex("#008547")
            public static let green3 = UIColor.fromHex("#03CD6E")
            public static let green4 = UIColor.fromHex("#CCE2D8")
            public static let green5 = UIColor.fromHex("#002D18")
            public static let green6 = UIColor.fromHex("#02A458")
            public static let green7 = UIColor.fromHex("#007840")
            public static let green8 = UIColor.fromHex("#00542D")
            
            public static let white = UIColor.fromHex("#FFFFFF")
            
            public static let blue1 = UIColor.fromHex("#0F385C")
            public static let blue2 = UIColor.fromHex("#1D70B8")
            public static let blue3 = UIColor.fromHex("#EFFFFF")
            
            public static let teal1 = UIColor.fromHex("#0D697C")
            
            public static let grey1 = UIColor.fromHex("#505A5F")
            public static let grey2 = UIColor.fromHex("#6F777B")
            public static let grey3 = UIColor.fromHex("#B1B4B6")
            public static let grey4 = UIColor.fromHex("#F3F2F1")
            public static let grey5 = UIColor.fromHex("#F2F2F7")
            public static let grey6 = UIColor.fromHex("#939393")
            public static let grey7 = UIColor.fromHex("#E7E6E5")
            public static let grey8 = UIColor.fromHex("#CECECE")
            
            public static let red1 = UIColor.fromHex("#D4351C")
            public static let red2 = UIColor.fromHex("#FF6961")
            public static let red3 = UIColor.fromHex("#55150B")
            public static let red4 = UIColor.fromHex("#9F2815")
            
            public static let pink1 = UIColor.fromHex("#F7DEE5")
            public static let pink2 = UIColor.fromHex("#FFF4FD")
            
            public static let yellow1 = UIColor.fromHex("#FFDD00")
            public static let yellow2 = UIColor.fromHex("#665800")
            public static let yellow3 = UIColor.fromHex("#FBF5B5")
            public static let yellow4 = UIColor.fromHex("#BFA600")
            
            public static let gold1 = UIColor.fromHex("#B89746")
            public static let gold1Alpha25 = UIColor.fromHex("#B89746").withAlphaComponent(0.25)
            public static let gold2 = UIColor.fromHex("#DDC78E")
            
            public static let background = UIColor.systemBackground
        }
        
        public enum Department {
            public static let ministryOfDefense = UIColor.fromHex("#532A45")
            public static let homeOffice = UIColor.fromHex("#732282")
            public static let hmRevenueAndCustoms = UIColor.fromHex("#008476")
            
            @available(*, deprecated, renamed: "departmentForTransport", message: "to be removed October 2025")
            public static let departmentOfTransport = departmentForTransport
            public static let departmentForTransport = UIColor.fromHex("#006853")
        }
    }
}

extension DesignSystem.Color {
    public enum GDSList {
        public static let marker: UIColor = DesignSystem.Color.Text.primary
        public static let label: UIColor = DesignSystem.Color.Text.primary
        public static let title: UIColor = DesignSystem.Color.Text.primary
    }
}

extension DesignSystem.Color {
    public enum GDSRow {
        public static let title: UIColor = UIColor.label
        public static let regSubtitle: UIColor = UIColor.label
        public static let tallSubtitle: UIColor = UIColor.secondaryLabel
        public static let detail: UIColor = UIColor.secondaryLabel
        public static let icon: UIColor = UIColor.tertiaryLabel
    }
}
