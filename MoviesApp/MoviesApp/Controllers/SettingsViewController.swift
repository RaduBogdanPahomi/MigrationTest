//
//  SettingsViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 10.10.2022.
//

import UIKit

enum CellType {
    case signIn
    case signOut
    case username(name: String?)
    
    func title() -> String? {
        switch self {
        case .signIn:
            return "Sign in"
        case .signOut:
            return "Sign out"
        case .username(let name):
            return name
        }
    }
    
    func shouldShowSignoutImage() -> Bool {
        switch self {
        case .signOut:
            return false
        case .username, .signIn:
            return true
        }
    }
    
    func textColor() -> UIColor {
        switch self {
        case .signOut:
            return .systemRed
        case .signIn:
            return .systemGreen
        default:
            return .white
        }
    }
}

class SettingsViewController: UIViewController {
    //MARK: - Private properties
    @IBOutlet private weak var tableView: UITableView!
    
    private let service: AuthServiceable = AuthService()
    private var accountName: String?
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(type: SettingsTableViewCell.self)
        loadUsername()
    }
}

//MARK: - Private API
private extension SettingsViewController {
    func fetchAccountDetails(sessionID: String, completion: @escaping (Result<Account, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getAccountDetails(sessionID: sessionID)
            completion(result)
        }
    }

    func loadUsername() {
        fetchAccountDetails(sessionID: UserManager.shared.sessionID ?? "") { result in
            switch result {
            case .success(let response):
                self.accountName = response.name
                self.tableView.reloadData()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
}

//MARK: - UITableViewDataSource protocol
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.shared.authStatus == .loggedOut ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: SettingsTableViewCell.self) as? SettingsTableViewCell else { return UITableViewCell() }

        var cellType = CellType.signIn
        if UserManager.shared.authStatus == .loggedIn && indexPath.row == 0 {
            cellType = .username(name: accountName)
        } else if indexPath.row == 1 {
            cellType = .signOut
        }
        
        cell.update(withType: cellType)
        return cell
    }
}

//MARK: - UITableViewDelegate protocol
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserManager.shared.authStatus == .loggedOut {
            performSegue(withIdentifier: "unwindToLogin", sender: self)
        } else if indexPath.row == 1 {
            showSignOutModal(title: "Are you sure you want to sign out?")
        }
    }
}
