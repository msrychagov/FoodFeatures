//
//  Models.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 25.03.2025.
//


struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
}

struct User: Codable {
    let id: Int
    let name: String
    let age: Int?
//    let preferences: [String]?
    let email: String
}


