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
    enum ShowAlert {
        struct Request {
            var message: String
        }
        struct Response {
            var message: String
        }
    }
    
    enum SwitchMainTabBar {
        struct Request {
            var tabBar: UITabBarController
        }
        
        struct Response {
            var tabBar: UITabBarController
        }
    }
    enum CheckFields {
        struct Request {
            var name: String?
            var email: String?
            var password: String?
            var preferences: [Preference]?
        }
        struct Response {
            var name: String
            var email: String
            var password: String
            var preferences: [Preference]
        }
    }
    
}

