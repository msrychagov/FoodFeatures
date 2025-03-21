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
        presenter.checkFields(response: SignUp.checkField.Response(name: request.name,
                                                                   age: request.age,
                                                                   sex: request.sex,
                                                                   preferences: request.preferences,
                                                                   email: request.email,
                                                                   password: request.password))
        worker.signUp(
            name: request.name,
            email: request.email,
            password: request.password,
            age: request.age,
            sex: request.sex,
            preferences: request.preferences)
    }
    func handleSignUpResult(success: Bool, message: String) {
        presenter.showAlert(response: SignUp.showAlert.Response(message: message)) {
            if success {
                self.presenter.routeToProfile(response: SignUp.routeToProfile.Response(navigationController: self.navigationController))
            }
        }
    }
}
