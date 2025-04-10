//
//  Worker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 25.03.2025.
//

import Foundation

final class ProductInfoWorker: ProductInfoWorkerLogic {
    
    private let interactor: ProductInfoBuisnessLogic

    init(interactor: ProductInfoBuisnessLogic) {
        self.interactor = interactor
    }

    func addFavorite(productId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        FavoriteService().addToFavorites(productId: productId, completion: completion)
    }

    func removeFavorite(productId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        FavoriteService().removeFromFavorites(productId: productId, completion: completion)
    }
    
    func isLiked(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        FavoriteService().isLiked(productId: productId) { result in
            completion(result)
        }
    }
    
    func isAuthed(completion: @escaping (Bool) -> Void) {
        completion(AuthManager.shared.isLoggedIn())
    }
    
    func downloadImage(url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Если ошибка или данных нет, просто выходим
            guard let data = data, error == nil else {
                return
            }
            completion(data)
        }.resume()
    }
}
