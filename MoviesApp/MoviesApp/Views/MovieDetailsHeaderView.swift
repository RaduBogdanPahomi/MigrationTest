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
    
    func update(withMovie movie: Movie) {
        movieTitleLabel.text = movie.originalTitle
        movieYearLabel.text = movie.releaseDate.getYear()
        movieLengthLabel.text = formatRuntime(forMovie: movie)
        movieRatingLabel.text = "\(movie.voteAverage.limitNumberOfDigits(forDouble: movie.voteAverage))/10"
    }
    
    func formatRuntime(forMovie movie: Movie) -> String {
        let totalHours = movie.runtime?.minutesToHours(movie.runtime ?? 0).hours
        let totalMinutes = movie.runtime?.minutesToHours(movie.runtime ?? 0).leftMinutes
        let formatedRuntime = "\(Int((totalHours) ?? 0))h" + " \(Int((totalMinutes) ?? 0))m"
        
        return formatedRuntime
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
