//
//  UIViewController+Extension.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 29.08.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showSignOutModal(title: String) {
        let alert = UIAlertController(title: title, message: .none, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) {
            UIAlertAction in
            KeychainHelper.standard.delete(service: Constants.Keychain.Service.username, account: Constants.Keychain.Account.TMDB)
            KeychainHelper.standard.delete(service: Constants.Keychain.Service.password, account: Constants.Keychain.Account.TMDB)
            UserManager.shared.authStatus = .loggedOut
            self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showDetail(`for` movie: Movie) {
        let service: MoviesServiceable = MovieService()
        Task(priority: .background) {
            let result = await service.getMovie(id: movie.id)
            switch result {
            case .success(let movie):
                let movieDetailsVC = MovieMoreDetailsViewController(nibName: "MovieMoreDetailsViewController", bundle: nil)
                movieDetailsVC.movie = movie
                navigationController?.pushViewController(movieDetailsVC, animated: true)
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
}
