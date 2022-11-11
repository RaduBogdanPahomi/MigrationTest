//
//  MovieDescriptionView.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 16.08.2022.
//

import UIKit

class MovieDescriptionView: UIView {
    // MARK: - Private properties
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var movieDescriptionLabel: UILabel!
    private var movie: Movie!
    
    //MARK: - Public properties
    weak var delegate: MovieDetailsProtocol?
    
    // MARK: - Public API
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func update(withMovie movie: Movie) {
        self.movie = movie
        movieDescriptionLabel.text = movie.overview
        getMovieTagLabels(forMovie: movie)
        
        ImageDownloader.shared.downloadImage(with: movie.composedPosterPath(), completionHandler: {[weak self] (image, cached) in
            self?.moviePosterImageView.image = image
        }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
    }
}

// MARK: - Private API
private extension MovieDescriptionView {
    func commonInit() {
        Bundle.main.loadNibNamed(MovieDescriptionView.identifier, owner: self, options: nil)
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func getMovieTagLabels(forMovie movie: Movie) {
        tagStackView.removeAllArrangedSubviews()
        if let genres = movie.genres {
            for genre in genres {
                let genreButton = UIButton()
                genreButton.tag = genres.firstIndex(of: genre) ?? -1
                genreButton.addTarget(self, action: #selector(tagButtonAction(_:)), for: .touchUpInside)
                genreButton.setTitle(genre.name, for: .normal)
                genreButton.setTitleColor(.white, for: .normal)
                genreButton.titleLabel?.numberOfLines = 0
                genreButton.borderWidth = 3
                genreButton.borderColor = .darkGray
                
                tagStackView.addArrangedSubview(genreButton)
            }
        }
    }
    
    @objc func tagButtonAction(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        guard let genre = movie.genres?[button.tag] else { return }
        
        delegate?.tappedGenreButton(genre: genre)
    }
}
