////
////  DataManager.swift
////  FoodFeatures
////
////  Created by Михаил Рычагов on 24.03.2025.
////
//
//import UIKit
//import CoreData
//
//class DataManager {
//    static let shared = DataManager()
//    private init() {}
//
//    // Получаем контекст из AppDelegate
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    // Функция для сохранения или обновления товара в Core Data
//    func saveProduct(from product: Product) {
//        // Попытаемся найти существующую запись по id
//        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
//        if let productId = product.id {
//            fetchRequest.predicate = NSPredicate(format: "id == %d", productId)
//        } else {
//            // Если id отсутствует, можно создать новый объект
//            // или пропустить сохранение
//            print("Нет id у товара")
//            return
//        }
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            let productEntity: ProductEntity
//            if let existingProduct = results.first {
//                productEntity = existingProduct
//            } else {
//                productEntity = ProductEntity(context: context)
//            }
//            
//            // Обновляем поля
//            productEntity.id = Int32(product.id ?? 0)
//            productEntity.name = product.name
//            productEntity.image_url = product.image_url
//            productEntity.store_id = Int32(product.store_id)
//            productEntity.productDescription = product.description
//            
//            try context.save()
//            print("Товар сохранён в Core Data")
//        } catch {
//            print("Ошибка сохранения товара: \(error)")
//        }
//    }
//
//    // Функция для извлечения всех товаров из Core Data
//    func fetchProducts() -> [ProductEntity] {
//        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
//        do {
//            let products = try context.fetch(fetchRequest)
//            return products
//        } catch {
//            print("Ошибка извлечения товаров: \(error)")
//            return []
//        }
//    }
//    
////    func fetchFavorites() -> [FavoritesEntity] {
////        let fetchRequest: NSFetchRequest<FavoritesEntity> = FavoritesEntity.fetchRequest()
////        do {
////            let favorites = try context.fetch(fetchRequest)
////            return favorites
////        } catch {
////            print("Ошибка извлечения товаров: \(error)")
////            return []
////        }
////    }
////    
//    // Можно добавить дополнительные методы, например, удаление товара
//    func deleteProduct(withId id: Int32) {
//        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
//        do {
//            let products = try context.fetch(fetchRequest)
//            if let productToDelete = products.first {
//                context.delete(productToDelete)
//                try context.save()
//                print("Товар удалён")
//            }
//        } catch {
//            print("Ошибка удаления товара: \(error)")
//        }
//    }
//}
