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
        struct Response {
            let token: String
        }
        struct ViewModelSuccess {
            let token: String
        }
        struct ViewModelFailure {
            let errorMessage: String
        }
    }
    enum checkFields {
        struct Response {
            var email: String
            var password: String
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

