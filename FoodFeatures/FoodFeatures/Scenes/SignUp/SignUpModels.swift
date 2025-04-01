import UIKit

enum SignUpModels {
    enum routeToProfile {
        struct Request {
            var navigationController: UINavigationController?
        }
        struct Response {
            var navigationController: UINavigationController?
        }
    }
    enum SignUp {
            struct Request {
                let name: String
                let age: Int
                let email: String
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
    enum UpdatePrefernces {
        struct Request {
            var preferenceIndex: Int
        }
        struct Response {
            var preferences: [Preference]
        }
        struct ViewModel {
            var preferences: [Preference]
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

