import UIKit

public extension UIViewController {
    func add(_ child: UIViewController, to view: UIView?) {
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        view?.translatesAutoresizingMaskIntoConstraints = false
        if let stackView = view as? UIStackView {
            stackView.addArrangedSubview(child.view)
        } else {
            view?.addSubview(child.view)
        }
        child.didMove(toParent: self)
    }
}
