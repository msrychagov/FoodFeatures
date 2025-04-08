//MARK: - BuisnessLogicProtocol
protocol UnAuthorizedUserBuisnessLogic {
    func routeToAuth(request: UnAuthorizedUser.RouteToAuth.Request)
}

//MARK: - PresenterProtocol
protocol UnAuthorizedUserPresenterLogic {
    func routeToAuth(response: UnAuthorizedUser.RouteToAuth.Response)
}

//MARK: - ViewProtocol
protocol UnAuthorizedUserViewLogic: AnyObject {
    
}
