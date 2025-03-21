import UIKit

enum SignIn {
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

