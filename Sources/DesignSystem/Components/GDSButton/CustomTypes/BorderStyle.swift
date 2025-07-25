import UIKit

public struct BorderStyle: Equatable {
    public let width: CGFloat
    public let color: UIColor
    
    public init(
        width: CGFloat,
        color: UIColor
    ) {
        self.width = width
        self.color = color
    }
}
