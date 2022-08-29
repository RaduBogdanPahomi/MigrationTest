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
   
    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        return tableview
    }()
    
    // MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        loadTableView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
    
// MARK: - Private API
private extension MoviesViewController {
    func setupUserInterface() {
        title = "All Movies"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setupTableView()
    }
    
    func fetchData(completion: @escaping (Result<MovieList, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getMovieList()
            completion(result)
        }
    }
    
    func loadTableView(completion: (() -> Void)? = nil) {
        let moviesVC = MoviesViewController()
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies = response.results
                self.tableview.reloadData()
                completion?()
            case .failure(let error):
                self.view.showModal(title: "Error", message: error.customMessage, vc: moviesVC)
                completion?()
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
        let movieDetailsVC = MovieDetailsViewController()
        let moviesVC = MoviesViewController()
        Task(priority: .background) {
            let result = await service.getMovie(id: movie.id)
            switch result {
            case .success(let movie):
                movieDetailsVC.update(withMovie: movie)
                navigationController?.pushViewController(movieDetailsVC, animated: true)
            case .failure(let error):
                view.showModal(title: "Error", message: error.customMessage, vc: moviesVC)
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
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        cell.tintColor = .white
        cell.update(withMovie: movies[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate protocol
extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(for: movies[indexPath.row])
    }
}
