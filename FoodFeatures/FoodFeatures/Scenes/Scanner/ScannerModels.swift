import UIKit

enum ScannerModels {
    enum Setup {
        struct Request {
            var view: UIView
        }
    }
    enum RouteToScannedProduct {
        struct Request {
            var navigationController: UINavigationController
        }
        struct Response {
            var navigationController: UINavigationController
            var barcode: String
        }
    }
    enum ScanSuccess {
        
    }
}

