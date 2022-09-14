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
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var plusButton: UIBarButtonItem!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var items: [FavoriteMovie]?
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    func fetchMovies() {
        do {
            self.items = try context.fetch(FavoriteMovie.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Fetch Error")
        }
    }
    
    func retrieveData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        do {
            let result = try context.fetch(fetchRequest)
        } catch {
            print("Retrieving Error")
        }
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Movie", message: "Add Movie", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            let text = alert.textFields![0]
            let newMovie = FavoriteMovie(context: self.context)
            newMovie.name = text.text
            self.title = newMovie.name
            do {
                try self.context.save()
            } catch {
                print("Saving Error")
            }
            self.fetchMovies()
        }
        
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Private API
private extension FavoriteMoviesViewController {
    func setupUserInterface() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        retrieveData()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(FavoriteMovieCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
}

// MARK: - UITableViewDataSource protocol
extension FavoriteMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let favorite = self.items?[indexPath.row]
        cell.textLabel?.text = favorite?.name ?? ""

        return cell
    }
}

// MARK: - UITableViewDelegate protocol
extension FavoriteMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
