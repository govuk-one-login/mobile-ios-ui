import UIKit

extension UIView {
    public func bindToSuperviewEdges(
        edges: NSDirectionalRectEdge = .all,
        padding: CGFloat = 0
    ) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil, call `addSubview(view: UIView)` before calling `bindToSuperviewEdges()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if edges.contains(.top) {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(
                    equalTo: superview.topAnchor,
                    constant: padding
                )
            ])
        }
        
        if edges.contains(.bottom) {
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(
                    equalTo: superview.bottomAnchor,
                    constant: -padding
                )
            ])
        }
        
        if edges.contains(.leading) {
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(
                    equalTo: superview.leadingAnchor,
                    constant: padding
                )
            ])
        }
        
        if edges.contains(.trailing) {
            NSLayoutConstraint.activate([
                self.trailingAnchor.constraint(
                    equalTo: superview.trailingAnchor,
                    constant: -padding
                )
            ])
        }
    }
    
    public func bindToSuperviewSafeArea(
        insetBy insets: UIEdgeInsets = .zero
    ) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil, call `addSubview(view: UIView)` before calling `bindToSuperviewSafeArea()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(
                equalTo: superview.safeAreaLayoutGuide.leadingAnchor,
                constant: insets.left
            ),
            self.trailingAnchor.constraint(
                equalTo: superview.safeAreaLayoutGuide.trailingAnchor,
                constant: -insets.right
            ),
            self.topAnchor.constraint(
                equalTo: superview.safeAreaLayoutGuide.topAnchor,
                constant: insets.top
            ),
            self.bottomAnchor.constraint(
                equalTo: superview.safeAreaLayoutGuide.bottomAnchor,
                constant: -insets.bottom
            )
        ])
    }
}
