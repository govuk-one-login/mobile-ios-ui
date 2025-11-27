import Foundation

extension DesignSystem {
    public enum Spacing {
        
        public enum GDSRow {
            public static let regularWithSubtitle: Double = 4
            public static let regularWithoutSubtitle: Double = 11
            public static let tallWithSubtitle: Double = 9
            public static let tallWithoutSubtitle: Double = 19
            
            public static let imageToTitleSpacing: Double = 12
        }
        
        public static let xSmall: Double = 4
        public static let small: Double = 8
        public static let `default`: Double = 16, medium: Double = 16
        public static let large: Double = 24
        public static let xLarge: Double = 32
    }
}

extension DesignSystem.Spacing {
    public enum GDSList {
        public static let leadingMargin: Double = 10
        public static let betweenRows: Double = 12
        public static let beforeLabel: Double = 20
    }
}
