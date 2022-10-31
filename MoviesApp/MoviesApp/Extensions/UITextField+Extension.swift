//
//  UITextField+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 28.10.2022.
//

import Foundation
import UIKit

extension UITextField {
    @IBInspectable var keyValue: String {
            get {
                return self.placeholder!
            }
            set(value) {
                self.placeholder = NSLocalizedString(value, comment: "")

            }
        }
}
