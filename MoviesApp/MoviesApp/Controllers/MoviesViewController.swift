//
//  ViewController.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 10.08.2022.
//

import UIKit

protocol FilterResultsDelegate {
    func didSelect(keyword: String)
}

class MoviesViewController: UIViewController {
    // MARK: - Private properties
    private var movies: [Movie] = []
    private var keywords: [Keyword] = []
    private var service: MoviesServiceable = MovieService()	
    private var page = 1
    private var isMovieRequestInProgress = false
    private var sortType: SortType = .popularity
    private var requestWasChanged = false
    private let filterResultsViewController = FilterResultsViewController()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: filterResultsViewController)
        searchController.searchResultsUpdater = self
        
        return  searchController
    }()

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
        setupNotification()
    }
}
    
// MARK: - Private API
private extension MoviesViewController {
    func setupUserInterface() {
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        filterResultsViewController.delegate = self
        
        setupTableView()
    }
    
    func fetchKeyword(completion: @escaping (Result<Keywords, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getSearchKeyword(keyword: searchController.searchBar.text ?? "")
            completion(result)
        }
    }

    func fetchData(withKeyword keyword: String, completion: @escaping (Result<MovieList, RequestError>) -> Void) {
        Task(priority: .background) {
            isMovieRequestInProgress = true
            if keyword.isEmpty == false {
                let result = await service.getSearchMovies(page: page, keyword: keyword)
                completion(result)
            } else {
                let result = await service.getMovieList(page: page, sortType: sortType.sortQueryParameter())
                completion(result)
            }
            isMovieRequestInProgress = false
        }
    }
    
    func loadTableView() {
        fetchData(withKeyword: searchController.searchBar.text ?? "") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if self.requestWasChanged == true {
                    self.movies.removeAll()
                    self.requestWasChanged = false
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
        tableview.registerCell(type: MovieTableViewCell.self)
        
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
                let movieDetailsVC = MovieMoreDetailsViewController()
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
                self?.requestWasChanged = true
                self?.page = 1
            }
            self?.sortType = sortType
            self?.loadTableView()
            self?.createSortMenu()
        }
        
        action.state = self.sortType == sortType ? .on : .off
        return action
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveNotification(_:)),
                                               name: .myNotification,
                                               object: nil)
    }
    
    @objc func didReceiveNotification(_ notification: NSNotification) {
        guard let notificationInfo = notification.userInfo,
              let movieId = notificationInfo["withId"],
              let movieIndex = movies.firstIndex(where: { movie in
                  movie.id == movieId as! Int
              }) else { tableview.reloadData(); return }
        
        tableview.reloadRows(at: [IndexPath(row: movieIndex, section: 0)], with: .automatic)
    }
}

// MARK: - UITableViewDataSource protocol
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueCell(withType: MovieTableViewCell.self) as? MovieTableViewCell else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        
        cell.delegate = self
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

//MARK: - MovieViewCellDelegate protocol
extension MoviesViewController: MovieCellDelegate {
    func markAsFavorite(movie: Movie, favorite: Bool) {
        FavoriteMoviesManager.shared.markMovie(movie: movie, asFavorite: favorite)
    }
}

//MARK: - UISearchBarDelegate protocol
extension MoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestWasChanged = true
        page = 1
        searchController.dismiss(animated: true, completion: nil)
        if #available(iOS 16.0, *) {
            navigationItem.rightBarButtonItem?.isHidden = true
        }
        loadTableView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        requestWasChanged = true
        if #available(iOS 16.0, *) {
            navigationItem.rightBarButtonItem?.isHidden = false
        }
        loadTableView()
    }
}

//MARK: - UISearchResultsUpdating protocol
extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        if searchController.searchBar.text?.isEmpty == true {
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
       
        fetchKeyword() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if searchController.searchBar.text?.isEmpty == true {
                    self.requestWasChanged = true
                    self.page = 1
                    self.loadTableView()
                }
                self.filterResultsViewController.update(withKeywords: response.results)
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
}

//MARK: - FilterResultsDelegate protocol
extension MoviesViewController: FilterResultsDelegate {
    func didSelect(keyword: String) {
        searchController.searchBar.text = keyword
        searchBarSearchButtonClicked(searchController.searchBar)
    }
}
