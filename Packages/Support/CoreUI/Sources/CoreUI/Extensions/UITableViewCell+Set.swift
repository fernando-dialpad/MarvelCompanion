import UIKit

public extension UITableViewCell {
    func set<T: UIView>(contentView: T) {
        subviews
            .filter { $0 is T }
            .forEach { $0.removeFromSuperview() }
        constrain(contentView)
    }
}
