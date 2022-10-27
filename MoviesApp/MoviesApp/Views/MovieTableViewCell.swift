//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 30.09.2022.
//

import Foundation
import UIKit


class MovieTableViewCell: UITableViewCell {
    //MARK: - Private properties
    private var movie: Movie?
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var movieDetailsView: MovieDetailsView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Public properties
    weak var delegate: MovieCellDelegate?
    
    //MARK: - Public API
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        tintColor = .white
        backgroundColor = .black
        selectionStyle = .none
    }
    
    func update(withMovie movie: Movie) {
        movieDetailsView.update(withMovie: movie)
        self.movie = movie
        activityIndicatorView.startAnimating()
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        let isFavorite = FavoriteMoviesManager.shared.isFavoriteMovie(id: movie.id)
        favoriteButton.isSelected = isFavorite
        
        ImageDownloader.shared.downloadImage(with: movie.composedPosterPath(), completionHandler: {[weak self] (image, cached) in
            self?.posterImageView.image = image
            self?.activityIndicatorView.stopAnimating()
        }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
    }
    
    func shouldHideFavorite(hide: Bool) {
        favoriteButton.isHidden = hide
    }
}
  
//MARK: - Private API
private extension MovieTableViewCell {
    @objc func favoriteButtonAction() {
        favoriteButton.isSelected = !favoriteButton.isSelected
        guard let movie else { return }
        delegate?.markAsFavorite(movie: movie, favorite: favoriteButton.isSelected)
    }
}
