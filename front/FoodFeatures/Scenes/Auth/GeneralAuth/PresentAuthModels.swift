import UIKit

enum GeneralAuthModels {
    enum ShowChildController {
        struct Request {
            let vc: UIViewController
        }
        struct Response {
            let vc: UIViewController
        }
        
        struct ViewModel {
            let vc: UIViewController
        }
    }
    
    enum RemoveChildController {
        struct Request {
            let vc: UIViewController
        }
        struct Response {
            let vc: UIViewController
        }
        struct ViewModel {
            let vc: UIViewController
        }
    }
}

