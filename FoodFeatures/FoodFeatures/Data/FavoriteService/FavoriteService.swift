//
//  FavoriteService.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 25.03.2025.
//
import Foundation

final class FavoriteService {
    private let baseURL = "http://172.20.10.2:8000"
    func removeFromFavorites(productId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/favorites/\(productId)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }
        
        guard let token = AuthManager.shared.getToken() else {
            completion(.failure(NSError(domain: "NoToken", code: 401)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                // Проверяем, что код ответа 2xx
                if !(200...299).contains(httpResponse.statusCode) {
                    // Сервер вернул ошибку
                    let bodyString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    let errorMsg = "Bad status \(httpResponse.statusCode): \(bodyString)"
                    completion(.failure(NSError(domain: errorMsg, code: httpResponse.statusCode)))
                    return
                }
            }
            
            // Если всё хорошо — успех
            completion(.success(()))
        }
        
        .resume()
        
        
    }
    // productId: Int — товар, который добавляем
    func addToFavorites(productId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // 1) Формируем URL, например, POST http://127.0.0.1:8000/favorites/{product_id}
        guard let url = URL(string: "\(baseURL)/favorites/\(productId)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }
        
        // 2) Проверяем, что у нас есть сохранённый токен
        guard let token = AuthManager.shared.getToken() else {
            completion(.failure(NSError(domain: "NoToken", code: 401)))
            return
        }
        
        print("Token in fetchFavorites:", token)
        
        // 3) Подготавливаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Добавляем заголовок Authorization
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        // 4) Отправляем запрос
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Проверяем ошибку сети
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Проверяем код ответа
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    // Сервер ответил ошибкой
                    // Можно посмотреть, что вернулось в data (JSON body)
                    let bodyString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    let errorMsg = "Bad status \(httpResponse.statusCode): \(bodyString)"
                    completion(.failure(NSError(domain: errorMsg, code: httpResponse.statusCode)))
                    return
                }
            }
            
            // Если всё ок, возвращаем успех
            completion(.success(()))
            
        }.resume()
    }
    
    func isLiked(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/favorites/\(productId)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }
        guard let token = AuthManager.shared.getToken() else {
            completion(.failure(NSError(domain: "NoToken", code: 401)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Проверка сетевой ошибки
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Проверка кода ответа
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    // Сервер вернул ошибку
                    let bodyString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    let errorMsg = "Bad status \(httpResponse.statusCode): \(bodyString)"
                    completion(.failure(NSError(domain: errorMsg, code: httpResponse.statusCode)))
                    return
                }
            }
            
            // Парсим JSON -> [Product]
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            
            do {
                let isLiked =  try JSONDecoder().decode(Bool.self, from: data)
                completion(.success(isLiked))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
    }
}
