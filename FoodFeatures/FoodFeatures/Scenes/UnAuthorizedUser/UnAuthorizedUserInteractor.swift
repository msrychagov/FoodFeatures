final class UnAuthorizedUserInteractor: UnAuthorizedUserBuisnessLogic {
    func routeToAuth(request: UnAuthorizedUser.RouteToAuth.Request) {
        presenter.routeToAuth(response: UnAuthorizedUser.RouteToAuth.Response(navigationController: request.navigationController))
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: UnAuthorizedUserPresenterLogic
    
    //MARK: - Lyfesycles
    init (presenter: UnAuthorizedUserPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    
    
}
