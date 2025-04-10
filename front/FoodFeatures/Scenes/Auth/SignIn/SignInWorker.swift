//
//  SignInWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 17.03.2025.
//

import UIKit

class SignInWorker: SignInWorkerLogic {
    func setUpTabBar() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let mainTabBar = sceneDelegate.window?.rootViewController as? MainTabBarController
        else {
            return
        }
        
        mainTabBar.switchToAuth()
    }
    
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
