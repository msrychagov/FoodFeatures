import UIKit

enum CategoriesModels {
    enum RouteToProductsList {
        struct Request {
            let navigationController: UINavigationController?
            let marketId: Int
            let category: Category
            let chapter: String
        }
        struct Response {
            let navigationController: UINavigationController?
            let marketId: Int
            let category: Category
            let chapter: String
        }
    }
    
    enum SetDisplayedCategories {
        struct Request {
            
        }
        
        struct Response {
            let categories: [Category]
        }
        
        struct ViewModel {
            let displayedCategories: [Category]
        }
    }
}

struct Category {
    let title: String
    let image: String
    let id: Int
}

