import UIKit

enum Markets {
    enum routeToCategories {
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
}

