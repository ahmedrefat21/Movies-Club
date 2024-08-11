//
//  UIViewController+Extension.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import UIKit

extension UIViewController {
    static var identifier: String {
       return String(describing: self)
    }

    static func instantiate () -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return  storyboard.instantiateViewController(identifier: identifier)
        as! Self
        
    }
}
