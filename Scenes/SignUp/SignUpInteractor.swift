import UIKit

final class SignUpInteractor: SignUpBuisnessLogic {
    
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    private let presenter: SignUpPresenterLogic
    private lazy var worker: SignUpWorker = SignUpWorker(interactor: self)
    private var navigationController: UINavigationController?
    
    //MARK: - Lyfesycles
    init (presenter: SignUpPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    
    func routeToProfile(request: SignUp.routeToProfile.Request) {
        presenter.routeToProfile(response: SignUp.routeToProfile.Response(navigationController: request.navigationController))
    }
    func registerUser(request: SignUp.registerUser.Request) {
        navigationController = request.navigationController
        presenter.checkFields(response: SignUp.checkField.Response(nameView: request.nameView, ageView: request.ageView, sexView: request.sexView, preferencesView: request.preferencesView, emailView: request.emailView, passwordView: request.passwordView))
        worker.signUp(
            name: request.nameView.textField.text!,
            email: request.emailView.textField.text!,
            password: request.passwordView.textField.text!,
            age: request.ageView.textField.text!,
            sex: request.sexView.textField.text!,
            preferences: request.preferencesView.textField.text!)
    }
    func handleSignUpResult(success: Bool, message: String) {
        presenter.showAlert(response: SignUp.showAlert.Response(message: message)) {
            if success {
                self.presenter.routeToProfile(response: SignUp.routeToProfile.Response(navigationController: self.navigationController))
            }
        }
    }
}
