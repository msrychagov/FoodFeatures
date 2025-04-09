//
//  UserService.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 07.04.2025.
//
import Foundation

class CurrentUserService {
    func updateCurrentUser(name: String, email: String, preferences: [String], completion: @escaping ((Result<User, Error>) -> Void)) {
        let url = URL(string: "\(GeneralConstants.baseURL)/users/me/update")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        guard let token = AuthManager.shared.getToken() else {
            completion(.failure(NSError(domain: "NoToken", code: 401)))
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "name": name,
            "email": email,
            "preferences": preferences
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                 completion(.failure(error))
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                // Сервер вернул, например, 400 или 401
                completion(.failure(NSError(domain: "Bad status code", code: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                // можно вернуть какую-то ошибку
                return
            }
            // 3) Парсим JSON
            do {
                let decoder = JSONDecoder()
                let updatedUser = try decoder.decode(User.self, from: data)
                // 4) Передаём массив во completion
                completion(.success(updatedUser))
            } catch {
                completion(.failure(error))
            }
            
            
        }.resume()
    }
}
