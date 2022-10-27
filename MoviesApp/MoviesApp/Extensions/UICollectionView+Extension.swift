//
//  UICollectionView+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 25.10.2022.
//

import Foundation
import UIKit

public extension UICollectionView {
    
    /**
     Register nibs faster by passing the type - if for some reason the `identifier` is different then it can be passed
     - Parameter type: UICollectionView.Type
     - Parameter identifier: String?
     */
    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
        let cellId = type.identifier
        register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: identifier ?? cellId)
    }
    
    /**
     DequeueCell by passing the type of UITableViewCell and IndexPath
     - Parameter type: UITableViewCell.TypeI
     - Parameter indexPath: IndexPath
     */
    func dequeueCell<T: UICollectionViewCell>(withType type: UICollectionViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
}
