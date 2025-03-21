import Foundation


class AuthService {
    // Важно: подставьте ваш реальный URL сервера
    private let baseURL = "http://127.0.0.1:8000"

    // Регистрация
    // На сервере должен быть эндпоинт /register, который возвращает {"access_token": "...", "token_type": "..."}
    func register(email: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Если сервер ожидает JSON:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
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
}
