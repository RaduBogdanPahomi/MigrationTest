//
//  SecondViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 17.08.2022.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Private properties
    private var service: MoviesServiceable = MovieService()
    private var movie: Movie?
    private var movies: [Movie] = []
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
        
    private let detailsHeaderView: MovieDetailsHeaderView = {
        let detailsHeaderView = MovieDetailsHeaderView()
        detailsHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return detailsHeaderView
    }()
    
    private let landscapePosterImageView: UIImageView = {
        let landscapePosterImageView = UIImageView()
        landscapePosterImageView.translatesAutoresizingMaskIntoConstraints = false
        landscapePosterImageView.image = UIImage(named: "LandscapeMoviePoster.jpeg")
        
        return landscapePosterImageView
    }()
    
    private let descriptionView: MovieDescriptionView = {
        let descriptionView = MovieDescriptionView()
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionView
    }()
    
    private let similarMoviesLabel: UILabel = {
        let similarMoviesLabel = UILabel()
        similarMoviesLabel.numberOfLines = 0
        similarMoviesLabel.translatesAutoresizingMaskIntoConstraints = false
        similarMoviesLabel.text = "Similar movies"
        similarMoviesLabel.textColor = .white
        
        return similarMoviesLabel
    }()
    
    private let collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: 250.0)
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionview
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicatorView
    }()
    
    // MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        loadCollectionView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func update(withMovie movie: Movie) {
        self.movie = movie
        detailsHeaderView.update(withMovie: movie)
        descriptionView.update(withMovie: movie)
    }
}

// MARK: - Private API
private extension MovieDetailsViewController {
    func setupUserInterface() {
        title = "\(movie?.originalTitle ?? "")"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(detailsHeaderView)
        scrollView.addSubview(landscapePosterImageView)
        landscapePosterImageView.addSubview(activityIndicatorView)
        scrollView.addSubview(descriptionView)
        scrollView.addSubview(similarMoviesLabel)
        
        if let validPath = movie?.composedBackdropPath() {
            activityIndicatorView.startAnimating()
            ImageDownloader.shared.downloadImage(with: validPath, completionHandler: {(image, cached) in
                self.landscapePosterImageView.image = image
                self.activityIndicatorView.stopAnimating()
            }, placeholderImage: UIImage(named: "MoviePoster.jpeg"))
        } else {
            landscapePosterImageView.image = UIImage(named: "MoviePoster.jpeg")
        }
        
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .black
        collectionview.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")

        scrollView.addSubview(collectionview)

        setupConstraints()
    }
    
    func fetchData(completion: @escaping (Result<SimilarMovies, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getSimilarMovies(id: movie?.id ?? 0)
            completion(result)
        }
    }
    
    func loadCollectionView(completion: (() -> Void)? = nil) {
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies = response.results
                self.collectionview.reloadData()
                completion?()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
                completion?()
            }
        }
    }
    
    func setupConstraints() {
        
        let scrollContentLayoutGuide = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollContentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            detailsHeaderView.topAnchor.constraint(equalTo: scrollContentLayoutGuide.topAnchor),
            detailsHeaderView.leadingAnchor.constraint(equalTo: scrollContentLayoutGuide.leadingAnchor),
            detailsHeaderView.trailingAnchor.constraint(equalTo: scrollContentLayoutGuide.trailingAnchor),
            
            landscapePosterImageView.topAnchor.constraint(equalTo: detailsHeaderView.bottomAnchor),
            landscapePosterImageView.leadingAnchor.constraint(equalTo: scrollContentLayoutGuide.leadingAnchor),
            landscapePosterImageView.trailingAnchor.constraint(equalTo: scrollContentLayoutGuide.trailingAnchor),

            activityIndicatorView.centerXAnchor.constraint(equalTo: landscapePosterImageView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: landscapePosterImageView.centerYAnchor),

            descriptionView.topAnchor.constraint(equalTo: landscapePosterImageView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: scrollContentLayoutGuide.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: scrollContentLayoutGuide.trailingAnchor),

            similarMoviesLabel.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20.0),
            similarMoviesLabel.leadingAnchor.constraint(equalTo: scrollContentLayoutGuide.leadingAnchor),

            collectionview.topAnchor.constraint(equalTo: similarMoviesLabel.bottomAnchor, constant: 20.0),
            collectionview.bottomAnchor.constraint(equalTo: scrollContentLayoutGuide.bottomAnchor),
            collectionview.leadingAnchor.constraint(equalTo: scrollContentLayoutGuide.leadingAnchor),
            collectionview.trailingAnchor.constraint(equalTo: scrollContentLayoutGuide.trailingAnchor),
            collectionview.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    func showDetail(`for` movie: Movie) {
        Task(priority: .background) {
            let result = await service.getMovie(id: movie.id)
            switch result {
            case .success(let movie):
                let movieDetailsVC = MovieDetailsViewController()
                movieDetailsVC.update(withMovie: movie)
                navigationController?.pushViewController(movieDetailsVC, animated: true)
            case .failure(let error):
                showModal(title: "Error", message: error.customMessage)
            }
        }
    }
    
    #warning("Remove this. THis will be kept in an UIViewController extension")
    private func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource protocol
extension MovieDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionview: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MovieCollectionViewCell
        
        cell.update(withMovie: movies[indexPath.section])
        return cell
    }
}

// MARK: - UICollectionViewDelegate protocol
extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetail(for: movies[indexPath.section])
    }
}
