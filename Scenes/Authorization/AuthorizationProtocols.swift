//MARK: - BuisnessLogicProtocol
protocol AuthorizationBuisnessLogic {
    func routeToSignIn(request: Authorization.routeToSignIn.Request)
    func routeToSignUp(request: Authorization.routeToSignUp.Request)
}

//MARK: - PresenterProtocol
protocol AuthorizationPresenterLogic {
    func routeToSignIn(response: Authorization.routeToSignIn.Response)
    func routeToSignUp(response: Authorization.routeToSignUp.Response)
}

//MARK: - ViewProtocol
protocol AuthorizationViewLogic: AnyObject {
    
}
