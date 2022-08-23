//
//  MovieHeaderView.swift
//  PharmacyLink
//
//  Created by bogdan.pahomi on 16.08.2022.
//

import UIKit

class MovieDetailsHeaderView: UIView {
    // MARK: - Private properties
	@IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieYearLabel: UILabel!
    @IBOutlet private weak var movieLengthLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var movieRatingLabel: UILabel!
    
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
        Bundle.main.loadNibNamed(MovieDetailsHeaderView.identifier, owner: self, options: nil)
		addSubview(contentView)
		
		NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
			contentView.topAnchor.constraint(equalTo: topAnchor),
			contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
