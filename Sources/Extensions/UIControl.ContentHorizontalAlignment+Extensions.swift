import UIKit

extension UIControl.ContentHorizontalAlignment {
    init(titleAlignment: UIButton.Configuration.TitleAlignment) {
        switch titleAlignment {
        case .leading:
            self = .leading
        case .trailing:
            self = .trailing
        default:
            self = .center
        }
    }
}
