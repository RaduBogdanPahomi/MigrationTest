//
//  FavoriteMoviesViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 13.09.2022.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    //MARK: - Private properties
    private var service: MoviesServiceable = MovieService()
    private var movies: [Movie] = []
    private var sortType: SortType = .popularity
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"),
                                         style: .plain,
                                         target: self,
                                         action: .none)
        
        return sortButton
    }()
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.movies = FavoriteMoviesManager.shared.favoriteMovies
        tableView.reloadData()
    }
}

//MARK: - Private API
private extension FavoriteMoviesViewController {
    func setupUserInterface() {
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = sortButton
        
        setupTableView()
    }
        
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableView)
        self.createSortMenu()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
    func showDetail(`for` movie: Movie) {
        Task(priority: .background) {
            let result = await service.getMovie(id: Int(movie.id))
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
    
    func createSortMenu() {
        var children = [UIAction]()
        for sortType in SortType.allCases {
            children.append(createActionItem(forSortType: sortType))
        }
        
        let sortMenu = UIMenu(title: "Sort by", children: children)
        sortButton.menu = sortMenu
    }
    
    func createActionItem(forSortType sortType: SortType) -> UIAction {
        let action = UIAction(title: sortType.rawValue) { [weak self] _ in
            if self?.sortType != sortType {
                self?.sortType = sortType
                self?.sortBy(sortType)
                self?.tableView.reloadData()
            }
            
            self?.createSortMenu()
        }
        
        action.state = self.sortType == sortType ? .on : .off
        return action
    }
    
    func sortBy(_: SortType) {
        switch sortType {
        case .popularity:
            movies = movies.sorted(by: { $1.popularity < $0.popularity })
        case .releaseDate:
            movies = movies.sorted(by: { $1.releaseDate < $0.releaseDate })
        case .rating:
            movies = movies.sorted(by: { $1.voteAverage < $0.voteAverage })
        case .ascTitle:
            movies = movies.sorted(by: { $0.originalTitle < $1.originalTitle })
        case .descTitle:
            movies = movies.sorted(by: { $1.originalTitle < $0.originalTitle })
        }
    }
}

// MARK: - UITableViewDataSource protocol
extension FavoriteMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
        cell.shouldHideFavorite(hide: true)
        cell.update(withMovie: movie)
        
        return cell
    }
}

// MARK: - UITableViewDelegate protocol
extension FavoriteMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(for: movies[indexPath.row])
    }
}
