//
//  Storyboarded.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 10/6/22.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

// Helper to get the main information of the ViewController
extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: Constants.STORYBOARD.NAME, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
