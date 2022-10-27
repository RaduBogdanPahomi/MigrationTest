//
//  ReviewsTableViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 21.10.2022.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {
    //MARK: - Private properties
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var reviewTitleLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var reviewLabel: UILabel!
    
    private var review: Review?
    
    //MARK: - Public API
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(withReview review: Review, movie: Movie) {
        ratingLabel.text = "\(review.authorDetails.rating ?? 0.0)"
        reviewTitleLabel.text = "\(movie.title)(\(movie.releaseDate.getYear() ?? ""))"
        usernameLabel.text = review.authorDetails.username
        dateLabel.text = "\(review.createdAt.prefix(10))"
        reviewLabel.text = review.content
    }
}
