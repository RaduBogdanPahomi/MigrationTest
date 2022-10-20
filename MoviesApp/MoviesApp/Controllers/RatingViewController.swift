//
//  RatingViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 18.10.2022.
//

import UIKit

class RatingViewController: UIViewController {
    //MARK: - Private properties
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var blurEffectView: UIVisualEffectView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var ratingSlider: UISlider!
    @IBOutlet private weak var rateButton: UIButton!
    @IBOutlet private weak var sliderValueLabel: UILabel!
    
    private var movie: Movie!
    private var service: MoviesServiceable = MovieService()
    
    //MARK: - Public properties
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func update(withMovie movie: Movie) {
        self.movie = movie
        ratingLabel?.text = "How would you rate \(movie.title)?"
        ratingSlider.value = Float(movie.voteAverage).round(toNearest: 0.5)
        sliderValueLabel.text = "\(ratingSlider.value.round(toNearest: 0.5))"
        
        ImageDownloader.shared.downloadImage(with: movie.composedPosterPath(), completionHandler: {[weak self] (image, cached) in
            self?.moviePosterImageView.image = image
        }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
    }
}

//MARK: - Private API
private extension RatingViewController {
    func rateMovie(movieID: Int, sessionID: String, rating: Float, completion: @escaping (Result<RatingResponse, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.postMovieRating(id: movieID, sessionID: sessionID, rating: rating)
            completion(result)
        }
    }
    
    @IBAction func dismissViewControllerAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func rateMovieAction(_ sender: Any) {
        rateMovie(movieID: movie.id, sessionID: UserManager.shared.sessionID ?? "", rating: ratingSlider.value.round(toNearest: 0.5)) { result in
            switch result {
            case .success(_):
                self.dismiss(animated: true)
                NotificationCenter.default.post(name: .didRate,
                                                object: self.ratingSlider.value.round(toNearest: 0.5))
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
    
    @IBAction func updateSliderValueLabel(_ sender: Any) {
        sliderValueLabel.text = "\(ratingSlider.value.round(toNearest: 0.5))"
    }
}
