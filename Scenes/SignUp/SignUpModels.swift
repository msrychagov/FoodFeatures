import UIKit

enum SignUp {
    enum routeToProfile {
        struct Request {
            var navigationController: UINavigationController?
        }
        struct Response {
            var navigationController: UINavigationController?
        }
    }
    enum registerUser {
        struct Request {
            var name: String
            var age: String
            var sex: String
            var preferences: String
            var email: String
            var password: String
            var navigationController: UINavigationController?
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
    enum checkField {
        struct Response {
            var name: String
            var age: String
            var sex: String
            var preferences: String
            var email: String
            var password: String
        }
    }
    
}

