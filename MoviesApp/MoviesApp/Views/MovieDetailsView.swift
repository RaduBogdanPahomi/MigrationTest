//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.08.2022.
//

import UIKit

class MovieDetailsView: UIView {
    // MARK: - Private properties
    private let containerStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    
    private let movieNameLabel: UILabel = {
        let movieNameLabel = UILabel()
        movieNameLabel.font = movieNameLabel.font.withSize(23)
        
        return movieNameLabel
    }()
    
    private let starImageView: UIImageView = {
        let starImageView = UIImageView()
        starImageView.contentMode = .scaleAspectFit
        starImageView.image = UIImage(named: "StarIcon.png")
        starImageView.setContentHuggingPriority(.required, for: .horizontal)
        
        return starImageView
    }()
    
    private let movieRatingLabel: UILabel = {
        let movieRatinglabel = UILabel()
        movieRatinglabel.font = movieRatinglabel.font.withSize(18)
        
        return movieRatinglabel
    }()
    
    private let movieYearLabel: UILabel = {
        let movieYearLabel = UILabel()
        movieYearLabel.font = movieYearLabel.font.withSize(18)
        
        return movieYearLabel
    }()
    
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
    
    func update(withMovie movie: Movie) {
        movieNameLabel.text = movie.originalTitle
        movieRatingLabel.text = "\(movie.voteAverage)"
        movieYearLabel.text = movie.releaseDate.getYear() ?? ""
    }    
}

// MARK: - Private API
private extension MovieDetailsView {
    func setupUserInterface() {
        containerStackView.axis = .vertical
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.spacing = 10.0
        
        movieNameLabel.numberOfLines = 0
        movieNameLabel.textColor = .white
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.spacing = 10.0

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
        
        addSubview(containerStackView)
        
        setupContraints()
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            starImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
