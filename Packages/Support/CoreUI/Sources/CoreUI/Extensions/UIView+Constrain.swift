import UIKit

public extension UIView {
    func constrain(_ subview: UIView, padding: UIEdgeInsets = .zero) {
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right),
            subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding.top),
            subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom)
        ])
    }

    func constrain(_ subview: UIActivityIndicatorView) {
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
