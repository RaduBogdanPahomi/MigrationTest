//
//  ViewController.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 10.08.2022.
//

import UIKit

class MoviesViewController: UIViewController {
    // MARK: - Private properties
    private var movies: [Movie] = []
    private var service: MoviesServiceable = MovieService()
    private var page = 1
    private var isMovieRequestInProgress = false
    private var action = ""
   
    enum SortType {
        case popularity
        case releaseDate
        case rating
        case ascTitle
        case descTitle
    }
    
    private let popularityItem = UIAction(title: "Popularity") {_ in
        print("Popularity")
    }
    
    private let releaseDateItem = UIAction(title: "Release date") {_ in
        print("Release date")
    }
    
    
    private let ratingItem = UIAction(title: "Rating") {_ in
        print("Rating")
    }
    
    private let titleAscendingItem = UIAction(title: "Title (A-Z)") {_ in
        print("Title (A-Z)")
    }
    
    private let titleDescendingItem = UIAction(title: "Title (Z-A)") {_ in
        print("Title (Z-A)")
    }

    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        return tableview
    }()

    private lazy var filterButton: UIBarButtonItem = {
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"),
                                           style: .plain,
                                           target: self,
                                           action: .none)
        
        return filterButton
    }()
    
    // MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        loadTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
}
    
// MARK: - Private API
private extension MoviesViewController {
    func setupUserInterface() {
        let menu = UIMenu(title: "Sort by", children: [popularityItem, releaseDateItem, ratingItem, titleAscendingItem, titleDescendingItem])
        filterButton.menu = menu
        title = "All Movies"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = filterButton
        setupTableView()
    }
    
    func fetchData(completion: @escaping (Result<MovieList, RequestError>) -> Void) {
        Task(priority: .background) {
            isMovieRequestInProgress = true
            let result = await service.getMovieList(page: page, action: action)
            isMovieRequestInProgress = false
            completion(result)
        }
    }
    
    func loadTableView() {
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies.append(contentsOf: response.results)
                self.tableview.reloadData()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .black
        tableview.register(MovieTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: view.leftAnchor)
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
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
}

// MARK: - UITableViewDataSource protocol
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
        
        cell.favoriteAction = { isFavorite in
            FavoriteMoviesManager.shared.markMovie(movie: movie, asFavorite: isFavorite)
        }
        
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        cell.tintColor = .white
        
        cell.update(withMovie: movie)
        
        
        return cell
    }
}

// MARK: - UITableViewDelegate protocol
extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(for: movies[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == movies.count && isMovieRequestInProgress == false {
            page += 1
            loadTableView()
        }
    }
}
