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
    @IBOutlet private weak var movieTagLabel: DesignableLabel!
    @IBOutlet private weak var movieDescriptionLabel: UILabel!
    
    // MARK: - Public API
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
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
}
