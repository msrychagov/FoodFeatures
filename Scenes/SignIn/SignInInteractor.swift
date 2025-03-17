final class SignInInteractor: SignInBuisnessLogic {
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: SignInPresenterLogic
    
    //MARK: - Lyfesycles
    init (presenter: SignInPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    func routeToProfile(request: SignIn.routeToProfile.Request) {
        presenter.routeToProfile(response: SignIn.routeToProfile.Response(navigationController: request.navigationController))
    }
    
}
