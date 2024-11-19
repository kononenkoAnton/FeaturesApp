//
//  UIViewController+AddChild.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/18/24.
//

import UIKit

extension UIViewController {
    func add(child: UIViewController, container: UIView) {
        addChild(child)
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
