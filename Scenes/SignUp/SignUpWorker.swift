//
//  SignUpWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 16.03.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

final class SignUpWorker {
    //MARK: - Variables
    private let interactor: SignUpBuisnessLogic
    //MARK: - Lyfecycles
    init(interactor: SignUpBuisnessLogic) {
        self.interactor = interactor
    }
    //MARK: - Methods
    
    func signUp(name: String,
                email: String,
                password: String,
                age: String,
                sex: String,
                preferences: String) {
        let name = name
        let age = age
        let email = email
        let password = password
        let preferences = preferences
        let sex = sex
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                    print("Ошибка Firebase: \(error.localizedDescription)") // ✅ Проверяем, ловится ли ошибка
                self.interactor.handleSignUpResult(success: false, message: "Ошибка регистрации: \(error.localizedDescription)")
                    return
                }
            
            guard let userId = authResult?.user.uid else { return }
            
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "name": name,
                "age": age,
                "email": email,
                "sex": sex,
                "preferences": preferences,
                "favorites": [] // Пустой список избранных товаров
            ]
            
            db.collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    print("Ошибка Firestore: \(error.localizedDescription)")
                    self.interactor.handleSignUpResult(success: false, message: "Ошибка сохранения данных: \(error.localizedDescription)")
                } else {
                    self.interactor.handleSignUpResult(success: true, message: "Регистрация успешна!")
                }
            }
        }
    }
}
