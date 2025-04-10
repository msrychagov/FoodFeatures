import UIKit
import Foundation

enum ProductInfoModels {
    enum ToggleFavorite {
        struct Request {
            let product: Product
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
        struct AlertViewModel {
            enum Kind {
                case auth
                case server
            }
            let kind: Kind
            let message: String   // общий текст ошибки
        }
    }
    
    enum IsAuthed {
        struct Response {
            let isAuthed: Bool
        }
        struct ViewModel {
            let isAuthed: Bool
        }
    }
    
    enum IsFavorite {
        struct Request {
            let product: Product
        }
        struct Response {
            let isFavorite: Bool
        }
        struct ViewModel {
            let isFavorite: Bool
        }
    }
    
    enum RouteToAuth {
        struct Request {
            let navigationController: UINavigationController?
        }
        struct Response {
            let navigationController: UINavigationController?
        }
    }
    
    enum SetImage {
        struct Request {
            let product: Product
        }
        struct Response {
            let data: Data?
        }
        struct ViewModel {
            let image: UIImage?
        }
    }
}

struct DescriptionField {
    var title: String
    var value: String
}
