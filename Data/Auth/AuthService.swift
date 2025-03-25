import Foundation

struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
    //    let user_id: Int
}

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    // Если нужно, добавьте age, bio и т.д.
}

class AuthService {
    // Важно: подставьте ваш реальный URL сервера
    private let baseURL = "http://127.0.0.1:8000"
    
    // Регистрация
    // На сервере должен быть эндпоинт /register, который возвращает {"access_token": "...", "token_type": "..."}
    func register(name: String, email: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Если сервер ожидает JSON:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "name": name,
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
    
    //    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
    //        guard let token = AuthManager.shared.getToken() else {
    //            completion(.failure(NSError(domain: "No token", code: 401, userInfo: nil)))
    //            return
    //        }
    //        guard let userId = AuthManager.shared.getUserId() else {
    //            completion(.failure(NSError(domain: "No userId", code: 0, userInfo: nil)))
    //            return
    //        }
    //
    //        // Собираем запрос
    //        guard let url = URL(string: "\(baseURL)/users/\(userId)") else {
    //            completion(.failure(NSError(domain: "Bad URL", code: 0, userInfo: nil)))
    //            return
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"
    //
    //        // Добавляем заголовок с токеном, если API требует авторизацию по Bearer-токену:
    //        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    //
    //        // Выполняем запрос
    //        URLSession.shared.dataTask(with: request) { data, response, error in
    //
    //            // Проверяем на ошибку сети
    //            if let error = error {
    //                completion(.failure(error))
    //                return
    //            }
    //
    //            // Проверяем что пришёл корректный HTTP-код, например 200
    //            if let httpResponse = response as? HTTPURLResponse,
    //               httpResponse.statusCode != 200 {
    //                completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
    //                return
    //            }
    //
    //            // Парсим data в структуру User
    //            guard let data = data else {
    //                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
    //                return
    //            }
    //
    //            do {
    //                let user = try JSONDecoder().decode(User.self, from: data)
    //                completion(.success(user))
    //            } catch {
    //                completion(.failure(error))
    //            }
    //
    //        }.resume()
    //    }
    
    func fetchCurrentUser(accessToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Замените URL на ваш реальный эндпоинт
        guard let url = URL(string: "http://127.0.0.1:8000/users/me") else {
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

// Допустим, вы хотите создать метод addToFavorites в AuthService.swift
// (можно вынести в отдельный сервис ProductsService или FavoritesService, но для примера оставим здесь)

extension AuthService {
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
        
        // (опционально) Если на сервере вы ожидаете JSON или x-www-form-urlencoded,
        // можно это указать. Но здесь у нас просто POST без тела.
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
//    func fetchFavorites(completion: @escaping (Result<[Product], Error>) -> Void) {
//        // 1) Формируем URL
//        guard let url = URL(string: "\(baseURL)/favorites/") else {
//            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
//            return
//        }
//        
//        // 2) Достаем токен
//        guard let token = AuthManager.shared.getToken() else {
//            completion(.failure(NSError(domain: "NoToken", code: 401)))
//            return
//        }
//        
//        print("Token in fetchFavorites:", token)
//        
//        // 3) Готовим GET-запрос
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        // Устанавливаем заголовок Authorization
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        // 4) Отправляем запрос
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            // Проверка сетевой ошибки
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            // Проверка кода ответа
//            if let httpResponse = response as? HTTPURLResponse {
//                if !(200...299).contains(httpResponse.statusCode) {
//                    // Сервер вернул ошибку
//                    let bodyString = String(data: data ?? Data(), encoding: .utf8) ?? ""
//                    let errorMsg = "Bad status \(httpResponse.statusCode): \(bodyString)"
//                    completion(.failure(NSError(domain: errorMsg, code: httpResponse.statusCode)))
//                    return
//                }
//            }
//            
//            // Парсим JSON -> [Product]
//            guard let data = data else {
//                completion(.failure(NSError(domain: "NoData", code: 0)))
//                return
//            }
//            
//            do {
//                let products = try JSONDecoder().decode([Product].self, from: data)
//                completion(.success(products))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
    
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
    
    
//    func isLiked(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
//           // Формируем URL: .../api/favorites/{product_id}
//           guard let url = URL(string: "\(baseURL)/\(productId)") else {
//               let error = NSError(domain: "InvalidURL", code: 0, userInfo: nil)
//               completion(.failure(error))
//               return
//           }
//           
//           // Получаем токен
//        guard let token = AuthManager.shared.getToken() else {
//               let error = NSError(domain: "NoToken", code: 0, userInfo: nil)
//               completion(.failure(error))
//               return
//           }
//           
//           // Настраиваем запрос
//           var request = URLRequest(url: url)
//           request.httpMethod = "GET"
//           // Вставляем заголовок Authorization: Bearer <token>
//           request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//           
//           // Запускаем dataTask
//           URLSession.shared.dataTask(with: request) { data, response, error in
//               // Если есть ошибка уровня сети
//               if let error = error {
//                   completion(.failure(error))
//                   return
//               }
//               
//               // Проверяем статус код
//               guard let httpResponse = response as? HTTPURLResponse else {
//                   let error = NSError(domain: "NoHTTPResponse", code: 0, userInfo: nil)
//                   completion(.failure(error))
//                   return
//               }
//               // Ожидаем 200 OK
//               guard httpResponse.statusCode == 200 else {
//                   // Если код не 200, посмотрим тело ответа
//                   let bodyString = String(data: data ?? Data(), encoding: .utf8) ?? ""
//                   let error = NSError(
//                       domain: "BadStatusCode",
//                       code: httpResponse.statusCode,
//                       userInfo: ["body": bodyString]
//                   )
//                   completion(.failure(error))
//                   return
//               }
//               
//               // Если данные пришли
//               guard let data = data else {
//                   let error = NSError(domain: "NoData", code: 0, userInfo: nil)
//                   completion(.failure(error))
//                   return
//               }
//               
//               // Пытаемся декодировать bool
//               do {
//                   let isLiked = try JSONDecoder().decode(Bool.self, from: data)
//                   completion(.success(isLiked))
//               } catch {
//                   completion(.failure(error))
//               }
//           }
//           .resume()
//       }
}
