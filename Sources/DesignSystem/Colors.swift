import UIKit

// As per Color defined in Figma design system:
extension DesignSystem {
    public enum Color {
        
        public enum Backgrounds {
        }
        
        public enum Dividers {
            public static let `default` = UIColor(
                light: Color.Base.grey2,
                dark: Color.Base.white
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
        }
        
        public enum Buttons {
            public static let primaryForeground = Color.Base.white
            public static let primaryBackground = Color.Base.green1
            
            public static let secondaryForeground = UIColor(
                light: Color.Base.green1,
                dark: Color.Base.green3
            )
            public static let secondaryForegroundFocus = Color.Base.black1
            public static let secondaryBackground = Color.Base.background
            
        }
       
        
        public enum Base {
            public static let black1 = UIColor.fromHex("#0B0C0C")
            
            public static let charcoal = UIColor.fromHex("#262626")
            
            public static let green1 = UIColor.fromHex("#00703C")
            public static let green2 = UIColor.fromHex("#008547")
            public static let green3 = UIColor.fromHex("#03CD6E")
            public static let green4 = UIColor.fromHex("#CCE2D8")
            public static let green5 = UIColor.fromHex("#002D18")
            public static let green6 = UIColor.fromHex("#029A53")
            public static let green7 = UIColor.fromHex("#007840")
            public static let green8 = UIColor.fromHex("#00542D")
            
            public static let white = UIColor.fromHex("#FFFFFF")
            
            public static let blue1 = UIColor.fromHex("#0F385C")
            public static let blue2 = UIColor.fromHex("#1D70B8")
            public static let blue3 = UIColor.fromHex("#EFFFFF")
            
            public static let teal = UIColor.fromHex("#0D697C")
            
            public static let grey1 = UIColor.fromHex("#505A54")
            public static let grey2 = UIColor.fromHex("#6F777B")
            public static let grey3 = UIColor.fromHex("#B1B4B6")
            public static let grey4 = UIColor.fromHex("#F3F2F1")
            public static let grey5 = UIColor.fromHex("#F2F2F7")
            public static let grey6 = UIColor.fromHex("#939393")
            
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
            public static let gold2 = UIColor.fromHex("#DDC78E")
            
            public static let darkPurple = UIColor.fromHex("#532A45")
            
            public static let background = UIColor.systemBackground
            
            
        }
    }
}
