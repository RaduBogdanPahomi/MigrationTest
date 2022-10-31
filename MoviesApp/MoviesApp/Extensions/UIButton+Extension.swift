//
//  UIButton+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 28.10.2022.
//

import Foundation
import UIKit

extension UIButton {
    @IBInspectable var keyValue: String {
            get {
                return (self.titleLabel?.text!)!
            }
            set(value) {
                self.setTitle(NSLocalizedString(value, comment: ""), for: .normal)
            }
        }
}
