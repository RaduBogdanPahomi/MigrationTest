//
//  GenreViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 08.11.2022.
//

import UIKit

class GenreViewController: UIViewController {
    //MARK: - Private properties
    @IBOutlet private weak var tableView: UITableView!
    private var movies: [Movie] = []
    private var service: MoviesServiceable = MovieService()
    private var isMovieRequestInProgress = false
    
    //MARK: - Public properties
    var genre: Genre!
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(type: MovieTableViewCell.self)
        loadTableView()
        navigationItem.title = genre.name
    }
}

//MARK: - Private API
private extension GenreViewController {
    func fetchData(completion: @escaping (Result<MovieList, RequestError>) -> Void) {
        Task(priority: .background) {
            isMovieRequestInProgress = true
            let result = await service.getMoviesWithGenre(genreID: genre.id ?? 0)
            isMovieRequestInProgress = false
            completion(result)
        }
    }
    
    func loadTableView() {
        fetchData() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies.append(contentsOf: response.results)
                self.tableView.reloadData()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
}
//MARK: - UITableViewDataSource protocol
extension GenreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: MovieTableViewCell.self) as? MovieTableViewCell else { return UITableViewCell() }
        cell.update(withMovie: movies[indexPath.row])
        
        return cell
    }
}

//MARK: - UITableViewDelegate protocol
extension GenreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(for: movies[indexPath.row])
    }
}
