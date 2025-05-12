import Foundation

extension DesignSystem {
    public enum DateFormat {
        /// Standard GOV.UK date format to present day without leading zero with full word month
        public static let `default`: String = "d MMMM yyyy"
        
        /// This is used for decoding dates with simple date string with reversed date components
        public static let reversedDate: String = "yyyy-MM-dd"
        
        /// This is used to create a Date from integer UTC date Int
        public static let utcIntToString: String = "yyyy-MM-dd HH:mm:ss z"
        
        /// This is used to create a Date from UTC date string
        public static let utcStringToDate: String = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }
}
