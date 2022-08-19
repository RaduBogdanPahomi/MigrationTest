//
//  MovieHeaderView.swift
//  PharmacyLink
//
//  Created by bogdan.pahomi on 16.08.2022.
//

import UIKit

class MovieDetailsHeaderView: UIView {
    //Private for all the @IBOutlet
	@IBOutlet private weak var contentView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieLengthLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var movieRatingLabel: UILabel!
    //create a function to update these values
    
	// MARK: - Public API
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
    
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
}

// MARK: - Private API
private extension MovieDetailsHeaderView {
	func commonInit() {
		Bundle.main.loadNibNamed("MovieDetailsHeaderView", owner: self, options: nil)
		addSubview(contentView)
		
		NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			contentView.topAnchor.constraint(equalTo: self.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
}
