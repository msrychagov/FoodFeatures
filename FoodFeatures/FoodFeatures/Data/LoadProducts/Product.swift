//
//  Product.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 22.03.2025.
//

struct Product: Decodable {
    let id: Int?
    let name: String
//    let price: Double
//    let discount: Double
//    let old_price: Double
//    let unit: String
    let image_url: String
    let store_id: Int
    let description: String
    // Возможно, categories: [Category] = []
}
