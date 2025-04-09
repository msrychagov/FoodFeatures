enum ProductsModels {
    enum Load {
        struct Request {
            // Если нужно передавать параметры (storeId, categoryId), можно добавить сюда:
            let storeId: Int
            let categoryId: Int
        }
        
        struct Response {
            // Сырой результат от Worker — список продуктов
            let products: [Product]
        }
        
        struct ViewModel {
            // То, что мы хотим отображать на экране
            let displayedProducts: [Product]
        }
    }
}
