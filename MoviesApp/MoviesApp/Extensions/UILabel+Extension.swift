//
//  UILabel+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 28.10.2022.
//

import Foundation
import UIKit

extension UILabel {
    @IBInspectable var keyValue: String {
            get {
                return self.text!
            }
            set(value) {
                self.text = NSLocalizedString(value, comment: "")

            }
        }
}
