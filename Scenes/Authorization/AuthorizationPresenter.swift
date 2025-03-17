import UIKit

final class AuthorizationPresenter: AuthorizationPresenterLogic {
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: AuthorizationViewLogic?
    
    //MARK: - Methods
    func routeToSignIn(response: Authorization.routeToSignIn.Response) {
        response.navigationController?.pushViewController(SignInAssembly.build(), animated: true)
    }
    
    func routeToSignUp(response: Authorization.routeToSignUp.Response) {
        response.navigationController?.pushViewController(SignUpAssembly.build(), animated: true)
    }
}
