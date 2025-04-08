enum ProductInfoModels {
    enum ToggleFavorite {
        struct Request {
            let productId: Int
            /// Текущее состояние избранного (true, если уже в избранном)
            let isCurrentlyFavorite: Bool
        }
        struct Response {
            /// Новое состояние (true, если теперь товар в избранном)
            let isFavoriteNow: Bool
        }
        struct ViewModelSuccess {
            let isFavoriteNow: Bool
        }
        struct ViewModelFailure {
            let errorMessage: String
        }
    }
}

struct DescriptionField {
    var title: String
    var value: String
}
