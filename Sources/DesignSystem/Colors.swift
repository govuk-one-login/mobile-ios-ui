import UIKit

// As per Color defined in Figma design system:
extension DesignSystem {
    public enum Color {
        
        public enum Backgrounds {
            public static let expiredWalletDocument = Color.grey4
            public static let veteranInformationHeader = Color.darkPurple
            public static let dbsInformationHeader = Color.dbsPurple
            public static let ninoInformationHeader = Color.hmrcGreen
        }
        
        public enum Dividers {
            public static let `default` = UIColor(
                light: Color.grey2,
                dark: Color.white
            )
        }
        
        public enum Borders {
            public static let statusTag = Color.red1
        }
        
        public enum Text {
            public static let statusTag = Color.red1
            public static let invalidWalletDocumentAction = Color.red1
            
            public static let primary = UIColor(
                light: Color.black1,
                dark: Color.white
            )
            
            public static let secondary = UIColor(
                light: Color.grey1,
                dark: Color.white
            )
        }
        
        public enum Buttons {
            public static let secondaryTextAndIcon = UIColor(
                light: Color.green1,
                dark: Color.green3
            )
            
            public static let focusStateTextAndIcon = Color.black1
        }
       
        
        // MARK: - Base Colors
        public static let black1 = UIColor.fromHex("#0B0C0C")
        
        public static let green1 = UIColor.fromHex("#00703C")
        public static let green2 = UIColor.fromHex("#008547")
        public static let green3 = UIColor.fromHex("#03CD6E")
        
        public static let white = UIColor.fromHex("#FFFFFF")
        
        public static let blue1 = UIColor.fromHex("#0F385C")
        public static let blue2 = UIColor.fromHex("#1D70B8")
        
        public static let teal = UIColor.fromHex("#008670")
        
        public static let grey1 = UIColor.fromHex("#505A54")
        public static let grey2 = UIColor.fromHex("#6F777B")
        public static let grey3 = UIColor.fromHex("#B1B4B6")
        public static let grey4 = UIColor.fromHex("#F3F2F1")
        
        public static let red1 = UIColor.fromHex("#D4351C")
        
        public static let yellow = UIColor.fromHex("#FFDD00")
        
        public static let purple = UIColor.fromHex("#774495")
        public static let darkPurple = UIColor.fromHex("#532A45")
        
        // MARK: - Temporay colors until replacements provided
        static let dbsPurple = UIColor.fromHex("#732282")
        static let hmrcGreen = UIColor.fromHex("#008476")
    }
}
