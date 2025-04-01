//
//  LoadProductsService.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 22.03.2025.
//

import Foundation

class LoadProductsService {
    private let baseURL = "http://172.20.10.2:8000"
    // Важно: подставьте ваш реальный URL сервера
    func fetchProducts(storeId: Int, categoryId: Int,
                       completion: @escaping (Result<[Product], Error>) -> Void)
    {
        // Формируем URL
        guard let url = URL(string: "\(baseURL)/stores/\(storeId)/categories/\(categoryId)/products")
        else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 1) Обрабатываем ошибку сети
            if let error = error {
                completion(.failure(error))
                return
            }
            
            
            // 2) Проверяем, что data не nil
            guard let data = data else {
                // можно вернуть какую-то ошибку
                return
            }
            // 3) Парсим JSON
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([Product].self, from: data)
//                products.forEach { product in
//                                    DataManager.shared.saveProduct(from: product)
//                                }
                // 4) Передаём массив во completion
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume() // запускаем запрос
    }
    
    func fetchFavoriteProducts(storeId: Int, categoryId: Int,
                       completion: @escaping (Result<[Product], Error>) -> Void)
    {
        // Формируем URL
        guard let url = URL(string: "\(baseURL)/favorites/\(storeId)/\(categoryId)")
        else {
            return
        }
        
        guard let token = AuthManager.shared.getToken() else {
            completion(.failure(NSError(domain: "NoToken", code: 401)))
            return
        }
        
        print("Token in fetchFavorites:", token)
        
        // 3) Подготавливаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Добавляем заголовок Authorization
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 1) Обрабатываем ошибку сети
            if let error = error {
                completion(.failure(error))
                return
            }
            
            
            // 2) Проверяем, что data не nil
            guard let data = data else {
                // можно вернуть какую-то ошибку
                return
            }
            // 3) Парсим JSON
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([Product].self, from: data)
                // 4) Передаём массив во completion
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume() // запускаем запрос
    }
}
