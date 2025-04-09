//
//  ProductsListWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 25.03.2025.
//


final class ProductsWorker: ProductsWorkerLogic {
    let interactor: ProductsBuisnessLogic
    
    init(interactor: ProductsBuisnessLogic) {
        self.interactor = interactor
    }

    func fetchProducts(storeId: Int, categoryId: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        // Здесь вызываем ваш сервис, например:
        LoadProductsService().fetchProducts(storeId: storeId, categoryId: categoryId) { result in
            // result: Result<[Product], Error>
            // Прокидываем дальше
            completion(result)
        }
    }
    
    func fetchFavoriteProducts(storeId: Int, categoryId: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        // Здесь вызываем ваш сервис, например:
        LoadProductsService().fetchFavoriteProducts(storeId: storeId, categoryId: categoryId) { result in
            // result: Result<[Product], Error>
            // Прокидываем дальше
            completion(result)
        }
    }
}
