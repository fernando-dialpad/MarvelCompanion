import UIKit

public extension UIColor {
    struct Main {
        public var searchBackground: UIColor { UIColor(named: "SearchBackground", in: .module, compatibleWith: nil) ?? .clear }
        public var warning: UIColor { UIColor(named: "Warning", in: .module, compatibleWith: nil) ?? .clear }
        public var link: UIColor { UIColor(named: "Link", in: .module, compatibleWith: nil) ?? .clear }
    }

    static var main: Main { Main() }
}
