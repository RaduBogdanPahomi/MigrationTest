//
//  ReviewsViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 21.10.2022.
//

import UIKit

class ReviewsViewController: UIViewController {
    //MARK: - Private properties
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieRatingLabel: UILabel!
    @IBOutlet private weak var rateButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private lazy var barChartView: BarChartView! = {
        let barChartView = BarChartView()
        barChartView.frame = view.frame
        return barChartView
    }()
    
    private var service: MoviesServiceable = MovieService()
    private var movie: Movie!
    private var reviews: [Review] = []
    private var isMovieRequestInProgress = false
    private var page = 1
    
    //MARK: Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "User reviews"
        movieTitleLabel?.text = "\(movie.title)"
        movieRatingLabel?.text = "\(movie.voteAverage.limitNumberOfDigits())"
        
        if UserManager.shared.authStatus == .loggedIn {
            rateButton.isHidden = false
        }
        
        loadTableView()
        
        NotificationCenter.default.addObserver(forName: .didRate,
                                                          object: nil,
                                                          queue: .main,
                                                          using: { [weak self] notification in
            guard let object = notification.object as? Float else { return }
            self?.rateButton.setTitle("\(object)/10", for: .normal)
            self?.rateButton.titleLabel?.font = UIFont.systemFont(ofSize: 28.0)
            self?.rateButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        })
        
        tableView.registerCell(type: ReviewsTableViewCell.self)
    }
    
    func update(withMovie movie: Movie) {
        self.movie = movie
    }
}

//MARK: - Private API
private extension ReviewsViewController {
    func getBarChartEntries() {
        for entry in 1...10 {
            let count = reviews.filter { $0.authorDetails.rating == Float(entry) }.count
            barChartView.dataEntries.append(count)
        }
    }
    
    @IBAction func rateMovieAction(_ sender: Any) {
        let ratingVC = RatingViewController()
        ratingVC.modalPresentationStyle = .overFullScreen
        self.present(ratingVC, animated: true)
        ratingVC.update(withMovie: movie)
    }
    
    func fetchReviews(completion: @escaping (Result<Reviews, RequestError>) -> Void) {
        Task(priority: .background) {
            isMovieRequestInProgress = true
            let result = await service.getMovieReviews(id: movie.id, page: page)
            completion(result)
        }
        isMovieRequestInProgress = false
    }
    
    func loadTableView() {
        fetchReviews() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.reviews.append(contentsOf: response.results)
                self.tableView.reloadData()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
            self.getBarChartEntries()
        }
    }
}

//MARK: - UITableViewDataSource protocol
extension ReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: ReviewsTableViewCell.self) as? ReviewsTableViewCell else { return UITableViewCell() }
        cell.update(withReview: reviews[indexPath.row], movie: movie)
        
        return cell
    }
}

//MARK: - UITableViewDelegate protocol
extension ReviewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == reviews.count && isMovieRequestInProgress == false {
            page += 1
            loadTableView()
        }
    }
}
