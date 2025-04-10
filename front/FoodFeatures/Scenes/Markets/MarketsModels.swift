import UIKit

enum Markets {
    enum RouteToCategories {
        struct Request {
            var navigationController: UINavigationController?
            var market: Market
            var chapter: String
        }
        struct Response {
            var navigationController: UINavigationController?
            var market: Market
            var chapter: String
        }
    }
    
    enum FetchMarkets {
        struct Request {
            
        }
        struct Response {
            let markets: [Market]
        }
        struct ViewModel {
            let markets: [Market]
        }
    }
}

