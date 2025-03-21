//
//  SignInWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 17.03.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInWorker {
    let interactor: SignInBuisnessLogic
    init (interactor: SignInBuisnessLogic) {
        self.interactor = interactor
    }
    func signIn (email: String, password: String) {
        let email = email
        let password = password
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.interactor.handleSignInResul(success: false, message: "Ошибка входа: \(error.localizedDescription)")
                return
            }

            guard let userId = authResult?.user.uid else { return }
            
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    // Данные пользователя загружены
                    let userData = document.data()
                    print("Данные пользователя: \(userData ?? [:])")
                    
                    self.interactor.handleSignInResul(success: true, message: "Успешный вход")
                } else {
                    self.interactor.handleSignInResul(success: false, message: "Ошибка загрузки данных: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                }
            }
        }
    }
}
