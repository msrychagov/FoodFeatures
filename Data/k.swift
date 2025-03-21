//
//  k.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 21.03.2025.
//

import Foundation
import Security

class KeychainHelper {

    static let standard = KeychainHelper()

    private init() {}

    // Сохранить строку в Keychain по заданному ключу
    func save(_ value: String, service: String, account: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            return false
        }

        // Удалим старую запись, если есть
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        SecItemDelete(query)

        // Добавляем новую
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary

        let status = SecItemAdd(attributes, nil)
        return status == errSecSuccess
    }

    // Получить строку из Keychain
    func read(service: String, account: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let stringValue = String(data: data, encoding: .utf8) else {
            return nil
        }

        return stringValue
    }

    // Удалить запись
    func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        SecItemDelete(query)
    }
}
