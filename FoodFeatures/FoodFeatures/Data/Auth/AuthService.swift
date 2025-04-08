import Foundation

class AuthService {
    
    func register(name: String, preferences: [String], email: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        guard let url = URL(string: "\(GeneralConstants.baseURL)/register") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Если сервер ожидает JSON:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "name": name,
            "preferences": preferences,
            "email": email,
            "password": password
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
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                // Сервер вернул, например, 400 или 401
                completion(.failure(NSError(domain: "Bad status code", code: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "Empty data", code: 0)))
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                completion(.success(tokenResponse))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    // Пример метода регистрации мы уже делали, теперь логин:
    func login(username: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        guard let url = URL(string: "\(GeneralConstants.baseURL)/login") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // В данном случае используем x-www-form-urlencoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Параметры: "username" и "password"
        let params = [
            "grant_type": "password",
            "username": username,
            "password": password,
            "client_id": "mobile_app",
            "client_secret": "secret"
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
    
    func fetchCurrentUser(accessToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Замените URL на ваш реальный эндпоинт
        guard let url = URL(string: "\(GeneralConstants.baseURL)/users/me") else {
            completion(.failure(NSError(domain: "Invalid url", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Передаём токен в заголовок
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 1) Проверяем на базовые ошибки
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                // можно вернуть какую-то ошибку
                return
            }
            // 3) Парсим JSON
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                // 4) Передаём массив во completion
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }

}
