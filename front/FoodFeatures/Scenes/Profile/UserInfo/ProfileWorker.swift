//
//  ProfileWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 18.04.2025.
//

import UIKit

final class ProfileWorker: ProfileWorkerLogic {
    func fetchUserInfo(completion: @escaping (Result<User, any Error>) -> Void) {
        let token = AuthManager.shared.getToken() ?? ""
        CurrentUserService().fetchCurrentUser(accessToken: token) { result in
            completion(result)
        }
    }
    
    func signOut() {
        AuthManager.shared.clearToken()
    }
    
    func setUpTabBar() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let mainTabBar = sceneDelegate.window?.rootViewController as? MainTabBarController
        else {
            return
        }
        
        mainTabBar.switchToUnauth()
    }
    
    private let interactor: ProfileBuisnessLogic
    
    init(interactor: ProfileBuisnessLogic) {
        self.interactor = interactor
    }
}
