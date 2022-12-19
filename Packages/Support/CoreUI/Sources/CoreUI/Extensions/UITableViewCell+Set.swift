import UIKit

public extension UITableViewCell {
    func set<T: UIView>(view: T, padding: UIEdgeInsets = .zero) {
        contentView.subviews
            .filter { $0 is T }
            .forEach { $0.removeFromSuperview() }
        contentView.addSubview(view)
        contentView.constrain(view, padding: padding)
    }
}
