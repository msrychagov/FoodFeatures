import UIKit

enum Favorites {
    enum Markets {
        struct Request {
            
        }
        struct Response {
            let markets: [Market]
        }
        
        struct ViewModel {
            let markets: [Market]
        }
    }
    
    enum RouteToCategories {
        struct Request {
            let navigationController: UINavigationController?
            let market: Market
            let chapter: String
        }
        struct Response {
            let navigationController: UINavigationController?
            let market: Market
            let chapter: String
        }
        struct ViewModel {
            let navigationController: UINavigationController?
            let market: Market
            let chapter: String
        }
    }
}

