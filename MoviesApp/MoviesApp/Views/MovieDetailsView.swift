//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.08.2022.
//

import UIKit

class MovieDetailsView: UIView {
    // MARK: - Public API
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    // MARK: - Private properties
    private let containerStackView = UIStackView()
    private let movieNameLabel = UILabel()
    private let movieRatingLabel = UILabel()
    private let movieYearLabel = UILabel()

    func update(withMovie movie: Movie) {
        movieNameLabel.text = movie.title
        movieRatingLabel.text = "\(movie.rating ?? 0)"
        movieYearLabel.text = "\(movie.releaseYear ?? 0)"
    }
}

// MARK: - Private API
private extension MovieDetailsView {
    func setupUserInterface() {
        containerStackView.axis = .vertical
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        movieNameLabel.numberOfLines = 0
        movieNameLabel.textColor = .white
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10.0
        
        let starImageView = UIImageView()
        starImageView.contentMode = .scaleAspectFit
        starImageView.image = UIImage(named: "StarIcon.png")
        starImageView.setContentHuggingPriority(.required, for: .horizontal)
        
        movieRatingLabel.numberOfLines = 0
        movieRatingLabel.textColor = .white
        movieRatingLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        movieYearLabel.numberOfLines = 0
        movieYearLabel.textColor = .gray
        movieYearLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        containerStackView.addArrangedSubview(movieNameLabel)
        containerStackView.addArrangedSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(starImageView)
        horizontalStackView.addArrangedSubview(movieRatingLabel)
        horizontalStackView.addArrangedSubview(movieYearLabel)
        
        self.addSubview(containerStackView)
        
        setupContraints()
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5.0)
        ])
    }
}


