//
//  am.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 21.03.2025.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    private let service = "com.myapp.auth"
    private let account = "accessToken"
    
    func saveToken(_ token: String) {
        KeychainHelper.standard.save(token, service: service, account: account)
    }
    
    func getToken() -> String? {
        KeychainHelper.standard.read(service: service, account: account)
    }
    
    func clearToken() {
        KeychainHelper.standard.delete(service: service, account: account)
    }
    
    // Сохранение userId
//    func saveUserId(_ userId: Int) {
//        let userIdString = String(userId)
//        KeychainHelper.standard.save(userIdString, service: service, account: account)
//    }
//    
//    // Чтение userId
//    func getUserId() -> Int? {
//        // Считываем строку из Keychain
//        if let userIdString = KeychainHelper.standard.read(service: service, account: account) {
//            // Преобразуем в Int
//            return Int(userIdString)
//        }
//        return nil
//    }
    
    func isLoggedIn() -> Bool {
        return getToken() != nil
    }
}
