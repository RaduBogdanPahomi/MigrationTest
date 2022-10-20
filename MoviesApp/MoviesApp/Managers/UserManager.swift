//
//  UserManager.swift
//  MoviesApp
//
//  Created by Tudor Ghilvacs on 20.10.2022.
//

import Foundation
import UIKit

public final class UserManager {
    static let shared = UserManager()
    let apiKey = "626d05abf324b3be1c089c695497d49c"
    var authStatus: AuthStatus = .loggedOut
    var sessionID: String? {
        didSet {
            authStatus = sessionID == nil ? .loggedOut : .loggedIn
        }
    }
}
