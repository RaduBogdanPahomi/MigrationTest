//
//  SettingsTableViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 10.10.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet private weak var cellLabel: UILabel!
    @IBOutlet private weak var signOutImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(withType type: CellType) {
        cellLabel.text = type.title()
        signOutImage.isHidden = type.shouldShowSignoutImage()
        cellLabel.textColor = type.textColor()
    }
}
