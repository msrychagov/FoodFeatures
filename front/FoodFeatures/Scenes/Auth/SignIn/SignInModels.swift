import UIKit

enum SignInModles {
    enum routeToProfile {
        struct Request {
            var navigationController: UINavigationController?
        }
        struct Response {
            var navigationController: UINavigationController?
        }
    }
    enum authUser {
        struct Request {
            var email: String
            var password: String
            var navigationController: UINavigationController?
        }
    }
    
    enum SignIn {
        struct Request {
            let username: String
            let password: String
        }
        struct Success {
            
        }
        
        struct Failure {
            let errorMessage: String
        }
        
        struct ViewModelSuccess {
            let token: String
        }
        struct ViewModelFailure {
            let errorMessage: String
        }
    }
    enum presentSignInResult {
        struct Response {
            let success: Bool
            let message: String
        }
    }
    enum showAlert {
        struct Request {
            var message: String
        }
        struct Response {
            var message: String
        }
    }
}

