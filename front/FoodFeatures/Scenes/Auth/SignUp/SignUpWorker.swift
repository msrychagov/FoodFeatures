//
//  SignUpWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 16.03.2025.
//

import Foundation
import UIKit

final class SignUpWorker: SignUpWorkerLogic {
    
    func signUp(name: String, preferences: [String], email: String, password: String, completion: @escaping (Result<TokenResponse, any Error>) -> Void) {
        AuthService().register(name: name, preferences: preferences, email: email, password: password, completion: completion)
    }
    
    func setUpTabBar () {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let mainTabBar = sceneDelegate.window?.rootViewController as? MainTabBarController
        else {
            return
        }
        
        mainTabBar.switchToAuth()
    }
    
    //MARK: - Variables
    private let interactor: SignUpBuisnessLogic
    //MARK: - Lyfecycles
    init(interactor: SignUpBuisnessLogic) {
        self.interactor = interactor
    }
    //MARK: - Methods
}
