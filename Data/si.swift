//
//  si.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 21.03.2025.
//

// TokenResponse.swift
import Foundation

struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
}

class AuuthService {
    private let baseURL = "http://127.0.0.1:8000"
    
    // Пример метода регистрации мы уже делали, теперь логин:
    func login(username: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // В данном случае используем x-www-form-urlencoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Параметры: "username" и "password"
        let params = [
            "username": username,
            "password": password
        ]
        
        // Собираем строку вида "username=fff@gmail.com&password=123456"
        let formBody = params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        // Превращаем строку в Data
        request.httpBody = formBody.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 1) Ошибка на сетевом уровне
            if let error = error {
                completion(.failure(error))
                return
            }
            // 2) Проверяем код ответа
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(NSError(domain: "Invalid status code", code: httpResponse.statusCode)))
                return
            }
            // 3) Проверяем Data
            guard let data = data else {
                completion(.failure(NSError(domain: "Empty response", code: 0)))
                return
            }
            // 4) Парсим JSON в TokenResponse
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                completion(.success(tokenResponse))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
