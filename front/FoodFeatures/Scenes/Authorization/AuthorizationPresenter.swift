import UIKit

final class AuthorizationPresenter: AuthorizationPresenterLogic {
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: (AuthorizationViewLogic & UIViewController)?
    
    //MARK: - Methods
    func routeToSignIn(response: Authorization.routeToSignIn.Response) {
        view?.navigationController?.pushViewController(SignInAssembly.build(), animated: true)
    }
    
    func routeToSignUp(response: Authorization.routeToSignUp.Response) {
        view?.navigationController?.pushViewController(SignUpAssembly.build(), animated: true)
    }
}
