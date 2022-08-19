//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 10.08.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    // MARK: - Public API
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private properties
    private let movieDetailsView = MovieDetailsView()
    private var posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return posterImageView
    }()
    
    private let favouriteButton: UIButton = {
        let favouriteButton = UIButton()
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.contentMode = .scaleAspectFit
        favouriteButton.tintColor = .white
        
        return favouriteButton
    }()
        
    func update(withMovie movie: Movie) {
        movieDetailsView.update(withMovie: movie)
    }
}

// MARK: - Private API
private extension MovieTableViewCell {
    func setupCellView() {
        setupSubviews()
        setupConstraints()
        
        let heartImage = UIImage(systemName: "heart")
        posterImageView.image = UIImage(named: "MoviePoster.jpeg")
        favouriteButton.setImage(heartImage, for: .normal)
    }
    
    func setupSubviews() {
        self.selectionStyle = .none
        backgroundColor = .black
        movieDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieDetailsView)
        
        posterImageView.addSubview(favouriteButton)
    }
       
    func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5.0),
            posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),

            movieDetailsView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 5.0),
            movieDetailsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5.0),
            movieDetailsView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                        
            favouriteButton.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 10),
            favouriteButton.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 20),
        ])
    }
}
