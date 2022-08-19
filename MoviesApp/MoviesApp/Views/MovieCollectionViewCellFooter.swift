//
//  MovieCollectionViewCellFooter.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 18.08.2022.
//

import UIKit

class MovieCollectionViewCellFooter: UIView {
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
    private let horizontalStackView = UIStackView()
    private let movieRatingLabel = UILabel()
    private let starImageView = UIImageView()

    func update(withMovie movie: Movie) {
        movieNameLabel.text = movie.title
        movieRatingLabel.text = "\(movie.rating ?? 0)"
    }
}

// MARK: - Private API
private extension MovieCollectionViewCellFooter {
    func setupUserInterface() {
        containerStackView.axis = .vertical
        containerStackView.backgroundColor = .darkGray
        containerStackView.spacing = 2.0
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 1.0
        
        movieNameLabel.numberOfLines = 0
        movieNameLabel.textColor = .white

        starImageView.contentMode = .scaleAspectFit
        starImageView.image = UIImage(named: "StarIcon.png")
        
        movieRatingLabel.numberOfLines = 0
        movieRatingLabel.textColor = .white
        
        containerStackView.addArrangedSubview(horizontalStackView)
        containerStackView.addArrangedSubview(movieNameLabel)
        
        horizontalStackView.addArrangedSubview(starImageView)
        horizontalStackView.addArrangedSubview(movieRatingLabel)
       
        self.addSubview(containerStackView)
        
        setupContraints()
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            horizontalStackView.topAnchor.constraint(equalTo: containerStackView.topAnchor, constant: 5.0),
            horizontalStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: 5.0),
            
            starImageView.heightAnchor.constraint(equalToConstant: 15),
            starImageView.widthAnchor.constraint(equalToConstant: 15),
            
            movieNameLabel.bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor)
        ])
    }
}
