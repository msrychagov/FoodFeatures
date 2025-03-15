//MARK: - BuisnessLogicProtocol
protocol SignInBuisnessLogic {
    func routeToProfile(request: SignIn.routeToProfile.Request)
}

//MARK: - PresenterProtocol
protocol SignInPresenterLogic {
    func routeToProfile(response: SignIn.routeToProfile.Response)
}

//MARK: - ViewProtocol
protocol SignInViewLogic: AnyObject {
    
}
