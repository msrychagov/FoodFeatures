import UIKit

enum ScannedProductModels {
    enum LoadProduct {
        struct Response {
            var scannedProductResponse: ScannedProductResponse
            var compatible: Bool
        }
        enum Success {
            struct ViewModel {
                var productName: String
                var brand: String
                var allergens: [Allergen]
                var traces: [String]
                var message: String
            }
        }
        enum Failure {
            struct Response {
                var error: Error
            }
            struct ViewModel {
                var errorMessage: String
            }
        }
    }
    
    enum GoBackToScanner {
        struct Request {
            var navigationController: UINavigationController?
        }
        struct Response {
            var navigationController: UINavigationController?
        }
    }
}


struct Allergen {
    var text: String
    var imageString: String
}
