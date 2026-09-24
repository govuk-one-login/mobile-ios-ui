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
        insetBy insets: NSDirectionalEdgeInsets = .zero,
        ignoringEdges: NSDirectionalRectEdge = .none
    ) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil, call `addSubview(view: UIView)` before calling `bindToSuperviewSafeArea()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let leadingAnchor = ignoringEdges.contains(.leading) ? superview.leadingAnchor : superview.safeAreaLayoutGuide.leadingAnchor
        let trailingAnchor = ignoringEdges.contains(.trailing) ? superview.trailingAnchor : superview.safeAreaLayoutGuide.trailingAnchor
        let topAnchor = ignoringEdges.contains(.top) ? superview.topAnchor : superview.safeAreaLayoutGuide.topAnchor
        let bottomAnchor = ignoringEdges.contains(.bottom) ? superview.bottomAnchor : superview.safeAreaLayoutGuide.bottomAnchor
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: insets.leading
            ),
            self.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -insets.trailing
            ),
            self.topAnchor.constraint(
                equalTo: topAnchor,
                constant: insets.top
            ),
            self.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -insets.bottom
            )
        ])
    }
}
