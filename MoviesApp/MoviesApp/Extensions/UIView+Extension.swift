//
//  UIView+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 17.08.2022.
//

import Foundation
import UIKit

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
