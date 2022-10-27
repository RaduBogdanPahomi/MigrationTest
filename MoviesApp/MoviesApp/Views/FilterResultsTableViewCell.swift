//
//  FilterResultsTableViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 06.10.2022.
//

import UIKit

class FilterResultsTableViewCell: UITableViewCell {
    //MARK: - Private properties
    @IBOutlet private weak var searchImageView: UIImageView!
    @IBOutlet private weak var keywordLabel: UILabel!
    
    private var keyword: Keyword?
    
    //MARK: - Public API
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(withKeyword keyword: String) {
        keywordLabel.text = keyword
    }
}
