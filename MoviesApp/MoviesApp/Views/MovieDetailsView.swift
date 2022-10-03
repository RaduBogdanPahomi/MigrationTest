//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 30.09.2022.
//

import Foundation
import UIKit

class MovieDetailsView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieRatingLabel: UILabel!
    @IBOutlet private weak var movieYearLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
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
    func commonInit() {
        Bundle.main.loadNibNamed(MovieDetailsView.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
