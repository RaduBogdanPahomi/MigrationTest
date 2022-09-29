//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 10.08.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    #warning("Make this cell from interface builder")
    // MARK: - Private properties
    private let movieDetailsView = MovieDetailsView()
    weak var delegate: MovieCellDelegate?
    private var movie: Movie?

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
    
    private let favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        favoriteButton.tintColor = .red
        let heartImageNormal = UIImage(systemName: "heart")
        let heartImageSelected = UIImage(systemName: "heart.fill")
        favoriteButton.setImage(heartImageNormal, for: .normal)
        favoriteButton.setImage(heartImageSelected, for: .selected)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)

        return favoriteButton
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
        self.movie = movie
        activityIndicatorView.startAnimating()
        
        let isFavorite = FavoriteMoviesManager.shared.isFavoriteMovie(id: movie.id)
        favoriteButton.isSelected = isFavorite
        
        ImageDownloader.shared.downloadImage(with: movie.composedPosterPath(), completionHandler: {(image, cached) in
            self.posterImageView.image = image
            self.activityIndicatorView.stopAnimating()
        }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
    }
        
    func shouldHideFavorite(hide: Bool) {
        favoriteButton.isHidden = hide
    }
    
    @objc func favoriteButtonAction() {
        favoriteButton.isSelected = !favoriteButton.isSelected
        guard let movie else { return }
        delegate?.markAsFavorite(movie: movie, favorite: favoriteButton.isSelected)
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
        
        accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        tintColor = .white

        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(posterImageView)
        horizontalStackView.addArrangedSubview(movieDetailsView)
        
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addSubview(favoriteButton)
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
                        
            favoriteButton.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40.0),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}
