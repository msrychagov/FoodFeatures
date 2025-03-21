import UIKit

final class SignInInteractor: SignInBuisnessLogic {
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: SignInPresenterLogic
    private lazy var worker: SignInWorker = SignInWorker(interactor: self)
    private var navigationController: UINavigationController?
    
    //MARK: - Lyfesycles
    init (presenter: SignInPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    func routeToProfile(request: SignIn.routeToProfile.Request) {
        presenter.routeToProfile(response: SignIn.routeToProfile.Response(navigationController: request.navigationController))
    }
    
    func handleSignInResul(success: Bool, message: String) {
        presenter.showAlert(response: SignIn.showAlert.Response(message: message)){
            if success {
                self.presenter.routeToProfile(response: SignIn.routeToProfile.Response(navigationController: self.navigationController))
            }
        }
    }
    
    func authUser(request: SignIn.authUser.Request) {
        navigationController = request.navigationController
        presenter.checkFields(response: SignIn.checkFields.Response(email: request.email, password: request.password))
        worker.signIn(email: request.email, password: request.password)
    }
    
}
