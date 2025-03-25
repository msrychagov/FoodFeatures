//
//  Worker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 25.03.2025.
//

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
}
