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
            var nameView: SignUpInputUserDataView
            var ageView: SignUpInputUserDataView
            var sexView: SignUpInputUserDataView
            var preferencesView: SignUpInputUserDataView
            var emailView: SignUpInputUserDataView
            var passwordView: SignUpInputUserDataView
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
            var nameView: SignUpInputUserDataView
            var ageView: SignUpInputUserDataView
            var sexView: SignUpInputUserDataView
            var preferencesView: SignUpInputUserDataView
            var emailView: SignUpInputUserDataView
            var passwordView: SignUpInputUserDataView
        }
    }
    
}

