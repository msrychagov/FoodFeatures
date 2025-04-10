import UIKit

enum ProfileModels {
    enum SignOut {
        struct Request {
            let navigationController: UINavigationController?
        }
        struct Response {
            let navigationController: UINavigationController?
        }
    }
    
    enum FetchUserInfoSuccess {
        struct Response {
            let user: User
        }
        struct ViewModel {
            let name: String
            let email: String
            let preferences: [String]
        }
    }
    
    enum FetchUserInfoFailure {
        struct Response {
            let error: Error
        }
        struct ViewModel {
            let errorMessage: String
        }
    }
    
    enum RouteToEditor {
        struct Request {
            let navigationController: UINavigationController?
        }
        struct Response {
            let navigationController: UINavigationController?
            let user: User
        }
    }
}

