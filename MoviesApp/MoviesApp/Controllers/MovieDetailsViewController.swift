//
//  SecondViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 17.08.2022.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private properties
    private let detailsHeaderView: MovieDetailsHeaderView = {
        let detailsHeaderView = MovieDetailsHeaderView()
        detailsHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return detailsHeaderView
    }()

    private let landscapePosterImageView: UIImageView = {
        let landscapePosterImageView = UIImageView()
        landscapePosterImageView.translatesAutoresizingMaskIntoConstraints = false
        landscapePosterImageView.image = UIImage(named: "LandscapeMoviePoster.jpeg")
        
        return landscapePosterImageView
    }()
    
    private let descriptionView: MovieDescriptionView = {
        let descriptionView = MovieDescriptionView()
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionView
    }()
    
    private let similarMoviesLabel: UILabel = {
        let similarMoviesLabel = UILabel()
        similarMoviesLabel.numberOfLines = 0
        similarMoviesLabel.translatesAutoresizingMaskIntoConstraints = false
        similarMoviesLabel.text = "Similar movies"
        similarMoviesLabel.textColor = .white
        
        return similarMoviesLabel
    }()
    
    private let collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: 300.0)
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionview
    }()
}

// MARK: - Private API
private extension MovieDetailsViewController {
    func setupUserInterface() {
        //To be added in a scroll view
        view.addSubview(detailsHeaderView)
        view.addSubview(landscapePosterImageView)
        view.addSubview(descriptionView)
        view.addSubview(similarMoviesLabel)
        
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .black
        collectionview .register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")

        view.addSubview(collectionview)

        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            detailsHeaderView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            detailsHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            landscapePosterImageView.topAnchor.constraint(equalTo: detailsHeaderView.bottomAnchor),
            landscapePosterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            landscapePosterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            descriptionView.topAnchor.constraint(equalTo: landscapePosterImageView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            similarMoviesLabel.topAnchor.constraint(equalTo: descriptionView.bottomAnchor),
            similarMoviesLabel.bottomAnchor.constraint(equalTo: collectionview.topAnchor, constant: -5.0),
            similarMoviesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            collectionview.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),	
            collectionview.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionview.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionview.heightAnchor.constraint(equalToConstant: 200.0)
        ])
    }
}

// MARK: - UICollectionViewDataSource protocol
extension MovieDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionview: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MovieCollectionViewCell
        
        let movie = Movie(name: "Spider-Man: No Way Home", rating: 7.5, year: 2021)
        cell.update(withMovie: movie)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate protocol
extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
