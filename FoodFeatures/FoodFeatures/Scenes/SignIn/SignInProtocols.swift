//MARK: - BuisnessLogicProtocol
protocol SignInBuisnessLogic {
    func signIn(request: SignInModles.SignIn.Request)
    func routeToProfile(request: SignInModles.routeToProfile.Request)
//    func authUser(request: SignInModles.authUser.Request)
    func handleSignInResul(success: Bool, message: String)
}

//MARK: - PresenterProtocol
protocol SignInPresenterLogic {
    func routeToProfile(response: SignInModles.routeToProfile.Response)
    func checkFields(response: SignInModles.checkFields.Response)
    func showAlert(response: SignInModles.showAlert.Response, completion: @escaping (() -> Void))
    func presentSignInSuccess(response: SignInModles.SignIn.Response)
    func presentSignInFailure(error: Error)
}

//MARK: - ViewProtocol
protocol SignInViewLogic: AnyObject {
    func showAlert(message: String, completion: (() -> Void)?)
    func displaySignInSuccess(viewModel: SignInModles.SignIn.ViewModelSuccess)
    func displaySignInFailure(viewModel: SignInModles.SignIn.ViewModelFailure)
}

protocol SignInWorkerLogic {
    func signIn(username: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void)
}
