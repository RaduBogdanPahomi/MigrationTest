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
        posterImageView.image = UIImage(named: "MoviePoster.jpeg")
        
        return posterImageView
    }()
    
    // MARK: - Public API
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.isUserInteractionEnabled = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(withMovie movie: Movie) {
        movieCollectionViewFooter.update(withMovie: movie)
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
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            movieCollectionViewFooter.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 5.0),
            movieCollectionViewFooter.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -5.0),
            movieCollectionViewFooter.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            movieCollectionViewFooter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
