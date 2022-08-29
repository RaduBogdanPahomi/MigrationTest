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

extension UIView {
    #warning("This function should be an extension for UIViewController. In this way, we will not need the VC parameter.")
    func showModal(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
