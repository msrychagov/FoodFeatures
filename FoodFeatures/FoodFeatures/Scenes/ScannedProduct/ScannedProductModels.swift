import UIKit

enum ScannedProductModels {
    enum LoadProduct {
        struct Response {
            var scannedProductResponse: ScannedProductResponse
        }
        enum Success {
            struct ViewModel {
                var productName: String
                var brand: String
            }
        }
    }
}


