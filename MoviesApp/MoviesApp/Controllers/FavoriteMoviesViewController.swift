//
//  FavoriteMoviesViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 13.09.2022.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    //MARK: - Private properties
    @IBOutlet private weak var tableView: UITableView!
    
    private var service: MoviesServiceable = MovieService()
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var sortType: SortType = .popularity
    private let manager = FavoriteMoviesManager()
    private let searchController = UISearchController()
    
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
        self.sortBy(sortType)
        tableView.reloadData()
    }
}

//MARK: - Private API
private extension FavoriteMoviesViewController {
    func setupUserInterface() {
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        tableView.registerCell(type: MovieTableViewCell.self)
        self.createSortMenu()
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
        guard let cell = tableView.dequeueCell(withType: MovieTableViewCell.self) as? MovieTableViewCell else { return UITableViewCell() }
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

//MARK: - UISearchResultsUpdating protocol
extension FavoriteMoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty == true {
            movies = FavoriteMoviesManager.shared.favoriteMovies
            tableView.reloadData()
        }
        
        movies = searchText.isEmpty ? movies : FavoriteMoviesManager.shared.favoriteMovies.filter({(movie: Movie) -> Bool in
            return movie.title.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
}
