//
//  UINavigationItem+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 28.10.2022.
//

import Foundation
import UIKit

extension UINavigationItem {
    @IBInspectable var keyValue: String {
            get {
                return self.title!
            }
            set(value) {
                self.title = NSLocalizedString(value, comment: "")

            }
        }
}

extension UIBarItem {
    @IBInspectable var keyValue: String {
            get {
                return self.title!
            }
            set(value) {
                self.title = NSLocalizedString(value, comment: "")

            }
        }
}

