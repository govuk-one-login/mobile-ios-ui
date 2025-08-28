import UIKit

extension NSTextAlignment {
    init(titleAlignment: UIButton.Configuration.TitleAlignment) {
        switch titleAlignment {
        case .leading:
            self = .left
        case .trailing:
            self = .right
        default:
            self = .center
        }
    }
}
