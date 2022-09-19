//
//  FavoritesViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 12.09.2022.
//

import Foundation
import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    lazy var dataProvider: FavoriteMovieProvider = {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let provider = FavoriteMovieProvider(with: managedContext, fetchedResultsControllerDelegate: self)
        return provider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // ...
    }
    
    func getData() {
        var urlRequest = URLRequest(url: URL(string: "https://raw.githubusercontent.com/johncodeos-blog/CoreDataNewsExample/main/news.json")!)
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData // We don't want Alamofire to store the data in the memory or disk
        AF.request(urlRequest).responseDecodable(of: FavoriteMovie.self) { response in
            self.processFectchedNewsPosts(news: response.value!)
        }
    }

    private func processFectchedNewsPosts(movies: FavoriteMovie) {
        for item in movies {
            NewsPosts.createOrUpdate(item: item, with: AppDelegate.sharedAppDelegate.coreDataStack)
        }
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in Core Data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .none)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .none)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .none)
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .update:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath!) as? MovieTableViewCell else { fatalError("xib doesn't exist") }
            let post = dataProvider.fetchedResultsController.object(at: indexPath!)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
