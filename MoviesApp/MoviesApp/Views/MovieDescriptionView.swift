//
//  MovieDescriptionView.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 16.08.2022.
//

import UIKit

class MovieDescriptionView: UIView {
    // MARK: - Private properties
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var movieDescriptionLabel: UILabel!
    
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
        movieDescriptionLabel.text = movie.overview		
        getMovieTagLabels(forMovie: movie)
        
        ImageDownloader.shared.downloadImage(with: movie.composedPosterPath(), completionHandler: {[weak self] (image, cached) in
            self?.moviePosterImageView.image = image
        }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
    }
}

// MARK: - Private API
private extension MovieDescriptionView {
    func commonInit() {
        Bundle.main.loadNibNamed(MovieDescriptionView.identifier, owner: self, options: nil)
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func getMovieTagLabels(forMovie movie: Movie) {
        tagStackView.removeAllArrangedSubviews()
        if let genres = movie.genres {
            for genre in genres {
                let genreLabel = UILabel()
                genreLabel.text = genre.name
                genreLabel.textColor = .white
                genreLabel.textAlignment = .center
                genreLabel.borderWidth = 3
                genreLabel.borderColor = .darkGray
                
                tagStackView.addArrangedSubview(genreLabel)
            }
        }
    }
}
