//
//  MovieCollectionViewCellFooter.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 18.08.2022.
//

import UIKit

class MovieCollectionViewCellFooter: UIView {
    // MARK: - Private properties
    private let containerStackView = UIStackView()
    private let movieNameLabel = UILabel()
    private let horizontalStackView = UIStackView()
    private let movieRatingLabel = UILabel()
    private let starImageView = UIImageView()
    
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
        movieRatingLabel.text = "\(movie.voteAverage.limitNumberOfDigits())"
    }
}

// MARK: - Private API
private extension MovieCollectionViewCellFooter {
    func setupUserInterface() {
        containerStackView.axis = .vertical
        containerStackView.backgroundColor = .secondaryLabel
        containerStackView.spacing = 10.0
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 1.0
        
        movieNameLabel.numberOfLines = 0
        movieNameLabel.font = .systemFont(ofSize: 13.0)
        movieNameLabel.textColor = .white

        starImageView.contentMode = .scaleAspectFit
        starImageView.image = UIImage(named: "StarIcon.png")
        
        movieRatingLabel.numberOfLines = 0
        movieRatingLabel.font = .systemFont(ofSize: 13.0)
        movieRatingLabel.textColor = .white
        
        containerStackView.addArrangedSubview(horizontalStackView)
        containerStackView.addArrangedSubview(movieNameLabel)
        
        horizontalStackView.addArrangedSubview(starImageView)
        horizontalStackView.addArrangedSubview(movieRatingLabel)
       
        addSubview(containerStackView)
        
        setupContraints()
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    
            starImageView.heightAnchor.constraint(equalToConstant: 15.0),
            starImageView.widthAnchor.constraint(equalToConstant: 15.0)
        ])
    }
}
