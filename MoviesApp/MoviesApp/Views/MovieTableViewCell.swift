//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 10.08.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    // MARK: - Private properties
    private let movieDetailsView = MovieDetailsView()

    private let horizontalStackView: UIStackView = {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10.0
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.alignment = .center

        return horizontalStackView
    }()
        
    private let posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.setContentHuggingPriority(.required, for: .horizontal)
        
        return posterImageView
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicatorView
    }()
    
    private let favouriteButton: UIButton = {
        let favouriteButton = UIButton()
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.tintColor = .white
        let heartImage = UIImage(systemName: "heart")
        favouriteButton.setImage(heartImage, for: .normal)

        return favouriteButton
    }()
    
    // MARK: - Public API
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withMovie movie: Movie) {
        movieDetailsView.update(withMovie: movie)
        activityIndicatorView.startAnimating()
        
        ImageDownloader.shared.downloadImage(with: movie.composedPosterPath(), completionHandler: {(image, cached) in
            self.posterImageView.image = image
            self.activityIndicatorView.stopAnimating()
        }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
    }
}

// MARK: - Private API
private extension MovieTableViewCell {
    func setupCellView() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        selectionStyle = .none
        backgroundColor = .black

        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(posterImageView)
        horizontalStackView.addArrangedSubview(movieDetailsView)
        
        posterImageView.addSubview(favouriteButton)
        posterImageView.addSubview(activityIndicatorView)
    }
       
    func setupConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 150.0),
            posterImageView.heightAnchor.constraint(equalToConstant: 225.0),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
                        
            favouriteButton.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 5.0),
            favouriteButton.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 5.0)
        ])
    }
}
