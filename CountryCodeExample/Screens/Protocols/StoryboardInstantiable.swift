//
//  StoryboardInstantiable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

import Foundation
import UIKit

public protocol StoryboardInstantiable {
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> Self
}

public extension StoryboardInstantiable where Self: UIViewController {
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }

    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(fileName)")
        }
        return vc
    }
}
