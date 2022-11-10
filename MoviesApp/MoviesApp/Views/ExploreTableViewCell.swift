//
//  ExploreTableViewCell.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 01.11.2022.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
//MARK: - Private properties
    @IBOutlet private weak var collectionView: UICollectionView!
    private var movies: [Movie] = []
    private var service: MoviesServiceable = MovieService()

//MARK: - Public properties
    var type: CollectionType!
    weak var delegate: ExploreVCDelegate?
    
//MARK: - Public API
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerCell(type: ExploreMovieCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func update(withMovies movies: [Movie]) {
        self.movies.append(contentsOf: movies)
        self.collectionView.reloadData()
    }
}

//MARK: - Private API
private extension ExploreTableViewCell {
    func showDetail(`for` movie: Movie) {
        Task(priority: .background) {
            let result = await service.getMovie(id: movie.id)
            switch result {
            case .success(let movie):
                delegate?.pushMovieDetailsVC(withMovie: movie)
            case .failure(let error):
                delegate?.showError(error: error.customMessage)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource protocol
extension ExploreTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: ExploreMovieCollectionViewCell.self, for: indexPath) as! ExploreMovieCollectionViewCell
        cell.update(withMovie: movies[indexPath.section])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate protocol
extension ExploreTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetail(for: movies[indexPath.section])
    }
}
