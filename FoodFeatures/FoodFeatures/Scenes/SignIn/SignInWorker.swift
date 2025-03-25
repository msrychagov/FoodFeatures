//
//  SignInWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 17.03.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInWorker: SignInWorkerLogic {
    let interactor: SignInBuisnessLogic
    init (interactor: SignInBuisnessLogic) {
        self.interactor = interactor
    }
    
    func signIn(username: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
            AuthService().login(username: username, password: password) { result in
                completion(result)
            }
        }
    
}
