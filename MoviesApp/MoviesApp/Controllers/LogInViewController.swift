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
    
    private var service: AuthServiceable = AuthService()
    private let keychain = KeychainHelper.standard
    private var sessionID: String?
    
    //MARK: - Public API
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTextFields()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        loginActivityIndicator.startAnimating()
        fetchToken() { [weak self] result in
            switch result {
            case .success(let response):
                self?.sendCredentials(token: response.requestToken) { result in
                    switch result {
                    case .success(_):
                        self?.saveCredentials()
                        self?.createSession(token: response.requestToken) { result in
                            switch result {
                            case .success(let response):
                                self?.errorLabel.isHidden = true
                                self?.loginActivityIndicator.stopAnimating()
                                UserManager.shared.sessionID = response.sessionId
                                self?.performSegue(withIdentifier: "mySegue", sender: nil)
                            case .failure(let error):
                                self?.showModal(title: "Error", message: error.customMessage)
                            }
                        }
                    case .failure(_):
                        self?.loginActivityIndicator.stopAnimating()
                        self?.passwordTextField.text?.removeAll()
                        self?.errorLabel.isHidden = false
                    }
                }
            case .failure(let error):
                self?.showModal(title: "Error", message: error.customMessage)
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
    
    func populateTextFields() {
        guard let usernameData = keychain.read(service: Constants.Keychain.Service.username, account: Constants.Keychain.Account.TMDB)
        else { return }
        guard let passwordData = keychain.read(service: Constants.Keychain.Service.password, account: Constants.Keychain.Account.TMDB)
        else { return }
        
        let username = String(data: usernameData, encoding: .utf8)
        let password = String(data: passwordData, encoding: .utf8)
        
        usernameTextField.text = username
        passwordTextField.text = password
    }
    
    func saveCredentials() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let usernameData = Data(username.utf8)
        let passwordData = Data(password.utf8)
        
        keychain.save(usernameData, service: Constants.Keychain.Service.username, account: Constants.Keychain.Account.TMDB)
        keychain.save(passwordData, service: Constants.Keychain.Service.password, account: Constants.Keychain.Account.TMDB)
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
