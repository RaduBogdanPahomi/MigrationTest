//
//  MovieVideosCollectionViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 25.10.2022.
//

import UIKit

class MovieVideosCollectionViewCell: UICollectionViewCell {
    //MARK: - Private properties
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var videoTypeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    private var video: VideoResult!
    
    //MARK: - Public API
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(withVideo video: VideoResult) {
        videoTitleLabel?.text = video.name
        videoTypeLabel?.text = video.type
        dateLabel?.text = "\(video.publishedAt.prefix(10))"
        
        let validPath = "http://img.youtube.com/vi/\(video.key)/hqdefault.jpg"
        ImageDownloader.shared.downloadImage(with: validPath, completionHandler: {[weak self] (image, cached) in
            self?.thumbnailImageView?.image = image
        }, placeholderImage: UIImage(named: "LandscapeMoviePoster.jpeg"))
    }
}
