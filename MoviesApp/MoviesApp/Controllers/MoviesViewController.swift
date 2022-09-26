//
//  ViewController.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 10.08.2022.
//

import UIKit

enum SortType: String, CaseIterable {
    case popularity = "Popularity"
    case releaseDate = "Release date"
    case rating = "Rating"
    case ascTitle = "Title (A-Z)"
    case descTitle = "Title (Z-A)"
    
    func sortQueryParameter() -> String {
        switch self {
        case .popularity:
             return "popularity.desc"
        case .releaseDate:
            return "release_date.desc"
        case .rating:
            return "vote_average.desc"
        case .ascTitle:
            return "original_title.asc"
        case .descTitle:
            return "original_title.desc"
        }
    }
}

class MoviesViewController: UIViewController {
    // MARK: - Private properties
    private var movies: [Movie] = []
    private var service: MoviesServiceable = MovieService()
    private var page = 1
    private var isMovieRequestInProgress = false
    private var sortType: SortType = .popularity
    private var sortTypeWasChanged = false
    
    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        return tableview
    }()

    private lazy var sortButton: UIBarButtonItem = {
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"),
                                         style: .plain,
                                         target: self,
                                         action: .none)
        
        return sortButton
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
        title = "All Movies"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = sortButton
        setupTableView()
    }
    
    func fetchData(completion: @escaping (Result<MovieList, RequestError>) -> Void) {
        Task(priority: .background) {
            isMovieRequestInProgress = true
            let result = await service.getMovieList(page: page, sortType: sortType.sortQueryParameter())
            isMovieRequestInProgress = false
            completion(result)
        }
    }
    
    func loadTableView() {
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if self.sortTypeWasChanged == true {
                    self.movies.removeAll()
                    self.sortTypeWasChanged = false
                }
                self.movies.append(contentsOf: response.results)
                self.createSortMenu()
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
    
    func createSortMenu() {
        var children = [UIAction]()
        for sortType in SortType.allCases {
            children.append(createActionItem(forSortType: sortType))
        }
        
        let sortMenu = UIMenu(title: "Sort by", children: children)
        sortButton.menu = sortMenu
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

    func createActionItem(forSortType sortType: SortType) -> UIAction {
        let action = UIAction(title: sortType.rawValue) { [weak self] _ in
            if self?.sortType != sortType {
                self?.sortTypeWasChanged = true
            }
            self?.sortType = sortType
            self?.loadTableView()
            self?.createSortMenu()
        }
        
        action.state = self.sortType == sortType ? .on : .off
        return action
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
