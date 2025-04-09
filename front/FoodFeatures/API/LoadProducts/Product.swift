//
//  Product.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 22.03.2025.
//

struct Product: Decodable {
    let id: Int?
    let name: String
    let description: String
    let image_url: String
    let specificies: String
    let fat_content: String
    let volume: String
    let compound: String
    let energy_value: String
    let protein: String
    let fats: String
    let carbs: String
    let store_id: Int
}
