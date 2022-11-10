//
//  ExploreViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 31.10.2022.
//

import Foundation
import UIKit

protocol ExploreVCDelegate: AnyObject {
    func pushMovieDetailsVC(withMovie movie: Movie)
    func showError(error: String)
}

class ExploreViewController: UIViewController {
    //MARK: - Private properties
    @IBOutlet private weak var tableView: UITableView!
   
    private var service: MoviesServiceable = MovieService()
    private var movies: [Movie] = []
    private var type = CollectionType.allCases
    private var page = 1
    private var isMovieRequestInProgress = false
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(type: ExploreTableViewCell.self)
    }
}

//MARK: - Private API
private extension ExploreViewController {
    func fetchExploreMovies(ofType type: String, completion: @escaping (Result<MovieList, RequestError>) -> Void) {
        Task(priority: .background) {
            isMovieRequestInProgress = true
            let result = await service.getExploreMovies(page: page, type: type)
            isMovieRequestInProgress = false
            completion(result)
        }
    }
    
    func fetchLatestMovie(completion: @escaping (Result<Movie, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getLatestMovie()
            completion(result)
        }
    }
}

//MARK: - UITableViewDataSource protocol
extension ExploreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CollectionType.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: ExploreTableViewCell.self, for: indexPath) as! ExploreTableViewCell
        cell.delegate = self
        
        if indexPath.section == 0 {
            fetchLatestMovie { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    cell.update(withMovies: [response])
                case .failure(let error):
                    self.showModal(title: "Error", message: error.customMessage)
                }
            }
        } else {
            fetchExploreMovies(ofType: type[indexPath.section].sortQueryParameter()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    cell.type = self.type[indexPath.section]
                    cell.update(withMovies: response.results)
                case .failure(let error):
                    self.showModal(title: "Error", message: error.customMessage)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return type[section].rawValue
    }
}

//MARK: - UITableViewDelegate protocol
extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.backgroundConfiguration?.backgroundColor = .black
    }
}

//MARK: - ExploreVCDelegate protocol
extension ExploreViewController: ExploreVCDelegate {
    func pushMovieDetailsVC(withMovie movie: Movie) {
        let movieDetailsVC = MovieMoreDetailsViewController(nibName: "MovieMoreDetailsViewController", bundle: nil)
        movieDetailsVC.movie = movie
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
    func showError(error: String) {
        self.showModal(title: "Error", message: error)
    }
}
