//
//  UIViewController+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 29.08.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
