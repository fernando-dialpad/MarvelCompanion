import UIKit

public extension UIColor {
    struct Main {
        public var contentBackground: UIColor { UIColor(named: "ContentBackground", in: .module, compatibleWith: nil) ?? .clear }
        public var warning: UIColor { UIColor(named: "Warning", in: .module, compatibleWith: nil) ?? .clear }
        public var link: UIColor { UIColor(named: "Link", in: .module, compatibleWith: nil) ?? .clear }
        public var accent: UIColor { UIColor(named: "Accent", in: .module, compatibleWith: nil) ?? .clear }
    }

    static var main: Main { Main() }
}
