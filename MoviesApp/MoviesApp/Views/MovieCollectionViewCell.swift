//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 17.08.2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
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
    
    // MARK: - Private properties
    private let movieCollectionViewFooter = MovieCollectionViewCellFooter()
    private var posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFit
        
        return posterImageView
    }()
    
    func update(withMovie movie: Movie) {
        movieCollectionViewFooter.update(withMovie: movie)
    }
}

// MARK: - Private API
private extension MovieCollectionViewCell {
    func setupCellView() {
        setupSubviews()
        setupConstraints()
        
        posterImageView.image = UIImage(named: "MoviePoster.jpeg")
    }
    
    func setupSubviews() {
        backgroundColor = .black
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieCollectionViewFooter)
        movieCollectionViewFooter.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            movieCollectionViewFooter.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 5.0),
            movieCollectionViewFooter.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -5.0),
            movieCollectionViewFooter.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            movieCollectionViewFooter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
