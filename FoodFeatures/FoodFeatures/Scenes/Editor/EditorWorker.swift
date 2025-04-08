//
//  EditorWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 06.04.2025.
//

class EditorWorker: EditorWorkerLogic {
    func saveChanges(name: String, email: String, preferences: [String], completion: @escaping (Result<User, Error>) -> Void) {
        CurrentUserService().updateCurrentUser(name: name, email: email, preferences: preferences) { result in
            completion(result)
        }
    }
    func fetchUser(token: TokenResponse) {
        return
    }
    
    //MARK: - Variables
    private let interactor: EditorBuisnessLogic
    
    //MARK: - Lyfecycle
    init(interactor: EditorBuisnessLogic) {
        self.interactor = interactor
    }
    
    
}
