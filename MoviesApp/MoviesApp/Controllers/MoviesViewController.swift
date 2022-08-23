//
//  ViewController.swift
//  MoviesApp
//
//  Created by bogdan.pahomi on 10.08.2022.
//

import UIKit

class MoviesViewController: UIViewController {
    private var movies: [Movie] = []
    private var service: MoviesServiceable = MovieService()
    
    // MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        loadTableView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private properties
    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        return tableview
    }()
}

// MARK: - Private API
private extension MoviesViewController {
    func setupUserInterface() {
        title = "All Movies"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setupTableView()
    }
    
    func fetchData(completion: @escaping (Result<TopRated, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getTopRated()
            completion(result)
        }
    }
    
    func loadTableView(completion: (() -> Void)? = nil) {
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies = response.results
                self.tableview.reloadData()
                completion?()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
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
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    func showDetail(`for` movie: Movie) {
        let movieDetailsVC = MovieDetailsViewController()
        Task(priority: .background) {
            let result = await service.getMovie(id: movie.id)
            switch result {
            case .success(_):
                navigationController?.pushViewController(movieDetailsVC, animated: true)
            case .failure(let error):
                showModal(title: "Error", message: error.customMessage)
            }
        }
    }
    
    private func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
