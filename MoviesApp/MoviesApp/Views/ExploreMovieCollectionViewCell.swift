//
//  ExploreMovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 02.11.2022.
//

import UIKit

class ExploreMovieCollectionViewCell: UICollectionViewCell {
    //MARK: - Private properties
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    
    //MARK: - Public API
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(withMovie movie: Movie) {
        ImageDownloader.shared.downloadImage(with: movie.composedPosterPath(), completionHandler: {[weak self] (image, cached) in
            self?.posterImageView.image = image
        }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
        
        movieTitleLabel.text = movie.title
    }
}
