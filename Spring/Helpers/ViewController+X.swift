//
//  ViewController+X.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

// MARK: - UIViewController
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
