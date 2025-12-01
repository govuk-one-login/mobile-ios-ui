import UIKit

extension NSDirectionalRectEdge {
    public static let all: NSDirectionalRectEdge = [.leading, .trailing, .top, .bottom]
    public static let horizontal: NSDirectionalRectEdge = [.leading, .trailing]
    public static let vertical: NSDirectionalRectEdge = [.top, .bottom]
    public static let none: NSDirectionalRectEdge = []
}
