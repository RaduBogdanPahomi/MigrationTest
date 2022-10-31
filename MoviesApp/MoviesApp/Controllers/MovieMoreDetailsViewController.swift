//
//  MovieMoreDetailsViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 26.10.2022.
//

import UIKit
import SafariServices
import WebKit

protocol MovieDetailsProtocol: AnyObject {
    func rateMovie()
    func movieReviews()
}

class MovieMoreDetailsViewController: UIViewController {
    // MARK: - Private properties
    @IBOutlet private weak var movieDetailsHeaderView: MovieDetailsHeaderView!
    @IBOutlet private weak var landscapePosterView: UIImageView!
    @IBOutlet private weak var movieDescriptionView: MovieDescriptionView!
    @IBOutlet private weak var videosLabel: UILabel!
    @IBOutlet private weak var videosCollectionView: UICollectionView!
    @IBOutlet private weak var moviesCollectionView: UICollectionView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private lazy var favoriteButton: UIBarButtonItem = {
        let favoriteButton = UIBarButtonItem(image: .none,
                                             style: .plain,
                                             target: self,
                                             action: #selector(favoriteButtonAction))
        let isFavorite = FavoriteMoviesManager.shared.isFavoriteMovie(id: movie.id)
        favoriteButton.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        favoriteButton.tintColor = .red
        
        return favoriteButton
    }()
    
    private var service: MoviesServiceable = MovieService()
    private var movies: [Movie] = []
    private var videos: [VideoResult] = []
    private var favMovie: FavoriteMovie!
    private var page = 1
    private var isMovieRequestInProgress = false
    
    // MARK: - Public properties
    var movie: Movie!
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        loadVideosCollectionView()
        loadCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.reloadInputViews()
    }
    
    @objc func favoriteButtonAction() {
        FavoriteMoviesManager.shared.changeFavoriteState(forMovie: movie)
        let isFavorite = FavoriteMoviesManager.shared.isFavoriteMovie(id: movie.id)
        
        let notficationInfo: [String : Any] = ["isFavorite" : isFavorite, "withId" : movie.id]
        NotificationCenter.default.post(name: .markAsFavorite, object: nil, userInfo: notficationInfo)
        favoriteButton.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
    }
}

// MARK: - Private API
private extension MovieMoreDetailsViewController {
    func setupUserInterface() {
        title = "\(movie?.title ?? "")"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = favoriteButton
       
        update(withMovie: movie)

        if let validPath = movie?.composedBackdropPath() {
            activityIndicatorView.startAnimating()
            ImageDownloader.shared.downloadImage(with: validPath, completionHandler: {[weak self] (image, cached) in
                self?.landscapePosterView.image = image
                self?.activityIndicatorView.stopAnimating()
            }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
        } else {
            landscapePosterView.image = UIImage(named: "MoviePoster.jpeg")
        }
        
        movieDetailsHeaderView.delegate = self
        
        videosCollectionView.registerCell(type: MovieVideosCollectionViewCell.self)
        moviesCollectionView.registerCell(type: MovieCollectionViewCell.self)
    }
    
    func update(withMovie movie: Movie) {
        movieDetailsHeaderView.update(withMovie: movie)
        movieDescriptionView.update(withMovie: movie)
        movieDetailsHeaderView.shouldHideRateButton(shouldHide: UserManager.shared.authStatus == .loggedOut)
    }
    
    func fetchData(completion: @escaping (Result<SimilarMovies, RequestError>) -> Void) {
        Task(priority: .background) {
            isMovieRequestInProgress = true
            let result = await service.getSimilarMovies(page: page, id: movie?.id ?? 0)
            isMovieRequestInProgress = false
            completion(result)
        }
    }
    
    func fetchVideos(completion: @escaping (Result<VideosResponse, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getVideos(id: movie.id)
            completion(result)
        }
    }
    
    func loadVideosCollectionView(completion: (() -> Void)? = nil) {
        fetchVideos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                for video in response.results {
                    if video.site == "YouTube" {
                        self.videos.append(video)
                    }
                }
                self.videosCollectionView.reloadData()
                self.videosLabel.text = "Videos: \(self.videos.count)"
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
    
    func loadCollectionView(completion: (() -> Void)? = nil) {
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies.append(contentsOf: response.results)
                self.moviesCollectionView.reloadData()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
    
    func presentWebView(url: URL) {
        let config = SFSafariViewController.Configuration()
        let webVC = SFSafariViewController(url: url, configuration: config)
        webVC.modalPresentationStyle = .fullScreen
        webVC.preferredBarTintColor = .black
        webVC.preferredControlTintColor = .white
        self.present(webVC, animated: true)
    }
    
    func showDetail(`for` movie: Movie) {
        Task(priority: .background) {
            let result = await service.getMovie(id: movie.id)
            switch result {
            case .success(let movie):
                let movieDetailsVC = MovieMoreDetailsViewController(nibName: "MovieMoreDetailsViewController", bundle: nil)
                navigationController?.pushViewController(movieDetailsVC, animated: true)
                movieDetailsVC.movie = movie
            case .failure(let error):
                showModal(title: "Error", message: error.customMessage)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource protocol
extension MovieMoreDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.moviesCollectionView {
            return movies.count
            
        } else {
            return videos.count
        }
    }
    
    func collectionView(_ collectionview: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.moviesCollectionView {
            let cell = moviesCollectionView.dequeueCell(withType: MovieCollectionViewCell.self, for: indexPath) as! MovieCollectionViewCell
            cell.update(withMovie: movies[indexPath.section])
            return cell
            
        } else {
            let video = videos[indexPath.section]
            let cell = videosCollectionView.dequeueCell(withType: MovieVideosCollectionViewCell.self, for: indexPath) as! MovieVideosCollectionViewCell
            cell.update(withVideo: video)
                
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate protocol
extension MovieMoreDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.moviesCollectionView {
            showDetail(for: movies[indexPath.section])
        } else {
            guard let url = URL(string: "https://youtu.be/\(videos[indexPath.section].key)") else { return }
            presentWebView(url: url)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == moviesCollectionView {
            if indexPath.section + 1 == movies.count && isMovieRequestInProgress == false {
                page += 1
                loadCollectionView()
            }
        }
    }
}

//MARK: - MovieDetails protocol
extension MovieMoreDetailsViewController: MovieDetailsProtocol {
    func rateMovie() {
        let ratingVC = RatingViewController()
        ratingVC.modalPresentationStyle = .overFullScreen
        self.present(ratingVC, animated: true)
        ratingVC.update(withMovie: movie)
    }
    
    func movieReviews() {
        let reviewsVC = ReviewsViewController()
        navigationController?.pushViewController(reviewsVC, animated: true)
        reviewsVC.update(withMovie: movie)
    }
}
