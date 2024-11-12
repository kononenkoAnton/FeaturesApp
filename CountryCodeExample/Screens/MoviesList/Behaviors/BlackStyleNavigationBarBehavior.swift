//
//  BlackStyleNavigationBarBehavior.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/12/24.
//

import UIKit.UIViewController

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {
    func viewDidLoad(viewController: UIViewController) {

        viewController.navigationController?.navigationBar.barStyle = .black
    }
}
