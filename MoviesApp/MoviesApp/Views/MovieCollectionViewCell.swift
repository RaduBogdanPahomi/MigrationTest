//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 25.10.2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    //MARK: - Private properties
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var movieRatingLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    
    //MARK: - Public API
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(withMovie movie: Movie) {
        ImageDownloader.shared.downloadImage(with: movie.composedPosterPath(), completionHandler: {[weak self] (image, cached) in
            self?.moviePosterImageView.image = image
        }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
        
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = "\(movie.voteAverage.limitNumberOfDigits())"
    }
}

