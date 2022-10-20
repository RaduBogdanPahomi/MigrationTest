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
    @IBOutlet private weak var movieYearLabel: UILabel!
    @IBOutlet private weak var movieLengthLabel: UILabel!
    @IBOutlet private weak var movieRatingLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var rateButton: UIButton!
    
    // MARK: - Public properties
    weak var delegate: MovieDetailsProtocol?
    
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
        movieLengthLabel.text = movie.formatRuntime()
        movieRatingLabel.text = "\(movie.voteAverage.limitNumberOfDigits())/10"
    }
    
    func shouldHideRateButton(shouldHide: Bool) {
        rateButton.isHidden = shouldHide
    }
}

// MARK: - Private API
private extension MovieDetailsHeaderView {
	func commonInit() {
        Bundle.main.loadNibNamed(MovieDetailsHeaderView.identifier, owner: self, options: nil)
		addSubview(contentView)
        NotificationCenter.default.addObserver(forName: .didRate,
                                                          object: nil,
                                                          queue: .main,
                                                          using: { [weak self] notification in
            guard let object = notification.object as? Float else { return }
            self?.rateButton.setTitle("\(object)/10", for: .normal)
            self?.rateButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        })
       
		NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
			contentView.topAnchor.constraint(equalTo: topAnchor),
			contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
    
    @IBAction func rateMovieAction(_ sender: Any) {
        delegate?.rateMovie()
    }
}
