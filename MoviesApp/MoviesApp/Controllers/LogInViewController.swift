//
//  LogInViewController.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 07.10.2022.
//

import UIKit

class LogInViewController: UIViewController {
    //MARK: - Private properties
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var loginActivityIndicator: UIActivityIndicatorView!

    private let service: AuthServiceable = AuthService()
    private var sessionID: String?
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? UITabBarController,
        let navControlers = destinationVC.viewControllers as? [UINavigationController] else { return }
        
        for navController in navControlers {
            if let settingsVC = navController.viewControllers.first as? SettingsViewController {
                settingsVC.sessionID = sessionID
            }
        }
    }
    
    @IBAction func signInAction(_ sender: Any) {
        loginActivityIndicator.startAnimating()
        fetchToken() { result in
            switch result {
            case .success(let response):
                self.sendCredentials(token: response.requestToken) { result in
                    switch result {
                    case .success(_):
                        self.createSession(token: response.requestToken) { result in
                            switch result {
                            case .success(let response):
                                self.errorLabel.isHidden = true
                                self.loginActivityIndicator.stopAnimating()
                                self.sessionID = response.sessionId
                                self.performSegue(withIdentifier: "mySegue", sender: nil)
                            case .failure(let error):
                                self.showModal(title: "Error", message: error.customMessage)
                            }
                        }
                    case .failure(_):
                        self.loginActivityIndicator.stopAnimating()
                        self.passwordTextField.text?.removeAll()
                        self.errorLabel.isHidden = false
                    }
                }
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        performSegue(withIdentifier: "mySegue", sender: nil)
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        
    }
}

//MARK: - Private API
private extension LogInViewController {
    func fetchToken(completion: @escaping (Result<LogInResponse, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getAuthenticationToken()
            completion(result)
        }
    }
    
    func sendCredentials(token: String, completion: @escaping (Result<LogInResponse, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.postCredentials(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", token: token)
            completion(result)
        }
    }
    
    func createSession(token: String, completion: @escaping (Result<Session, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.createSession(token: token)
            completion(result)
        }
    }
}

//MARK: - UITextFieldDelegate protocol
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.endEditing(true)
        passwordTextField.becomeFirstResponder()
        return true
    }
}
