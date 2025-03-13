final class AuthorizationInteractor: AuthorizationBuisnessLogic {
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: AuthorizationPresenterLogic
    
    //MARK: - Lyfesycles
    init (presenter: AuthorizationPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    func routeToSignIn(request: Authorization.routeToSignIn.Request) {
        presenter.routeToSignIn(response: Authorization.routeToSignIn.Response(navigationController: request.navigationController))
    }
    
    func routeToSignUp(request: Authorization.routeToSignUp.Request) {
        presenter.routeToSignUp(response: Authorization.routeToSignUp.Response(navigationController: request.navigationController))
    }
    
}
