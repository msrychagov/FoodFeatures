//MARK: - BuisnessLogicProtocol
protocol SignInBuisnessLogic {
    func routeToProfile(request: SignIn.routeToProfile.Request)
    func authUser(request: SignIn.authUser.Request)
    func handleSignInResul(success: Bool, message: String)
}

//MARK: - PresenterProtocol
protocol SignInPresenterLogic {
    func routeToProfile(response: SignIn.routeToProfile.Response)
    func checkFields(response: SignIn.checkFields.Response)
    func showAlert(response: SignIn.showAlert.Response, completion: @escaping (() -> Void))
}

//MARK: - ViewProtocol
protocol SignInViewLogic: AnyObject {
    func showAlert(message: String, completion: (() -> Void)?)
}
