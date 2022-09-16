//
//  FavoriteMoviesViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 13.09.2022.
//

import UIKit
import CoreData

class FavoriteMoviesViewController: UIViewController {
    //MARK: - Private properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var viewModel = FavoriteMovieViewModel()
    private var service: MoviesServiceable = MovieService()
    private var movies: [FavoriteMovie] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.movies = viewModel.getAllFavouriteMovies() ?? []
        tableView.reloadData()
    }
}

//MARK: - Private API
private extension FavoriteMoviesViewController {
    func setupUserInterface() {
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setupTableView()
    }
        
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
    func showDetail(`for` movie: FavoriteMovie) {
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
}

// MARK: - UITableViewDataSource protocol
extension FavoriteMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MovieTableViewCell
        let favorite = movies[indexPath.row]
        cell.updateFavorite(withFavorite: favorite)
        
        return cell
    }
}

// MARK: - UITableViewDelegate protocol
extension FavoriteMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(for: movies[indexPath.row])
    }
}
