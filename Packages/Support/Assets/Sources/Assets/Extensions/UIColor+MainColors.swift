import UIKit

public extension UIColor {
    struct Main {
        public var warning: UIColor { UIColor(named: "Warning", in: .module, compatibleWith: nil) ?? .clear }
    }

    static var main: Main { Main() }
}
