//
//  SignUpWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 16.03.2025.
//

import Foundation
import UIKit

final class SignUpWorker: SignUpWorkerLogic {
    
    func signUp(name: String, age: Int, preferences: [String], email: String, password: String, completion: @escaping (Result<TokenResponse, any Error>) -> Void) {
        AuthService().register(name: name, age: age, preferences: preferences, email: email, password: password, completion: completion)
    }
    
    //MARK: - Variables
    private let interactor: SignUpBuisnessLogic
    //MARK: - Lyfecycles
    init(interactor: SignUpBuisnessLogic) {
        self.interactor = interactor
    }
    //MARK: - Methods
}
