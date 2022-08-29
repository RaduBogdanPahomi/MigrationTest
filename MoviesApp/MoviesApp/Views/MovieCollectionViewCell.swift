//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 17.08.2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Private properties
    private let movieCollectionViewFooter = MovieCollectionViewCellFooter()
    private var posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFit
        
        return posterImageView
    }()
    
    // MARK: - Public API
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    func update(withMovie movie: Movie) {
        movieCollectionViewFooter.update(withMovie: movie)
        
        ImageDownloader.shared.downloadImage(with: movie.composedPosterPath(), completionHandler: {(image, cached) in
            self.posterImageView.image = image
        }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
    }
}

// MARK: - Private API
private extension MovieCollectionViewCell {
    func setupCellView() {
        backgroundColor = .black
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieCollectionViewFooter)
        movieCollectionViewFooter.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 200.0),
            
            movieCollectionViewFooter.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            movieCollectionViewFooter.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            movieCollectionViewFooter.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
        ])
    }
}
