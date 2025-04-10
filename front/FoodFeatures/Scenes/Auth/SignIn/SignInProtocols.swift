//MARK: - BuisnessLogicProtocol
protocol SignInBuisnessLogic {
    func signIn(request: SignInModles.SignIn.Request)
}

//MARK: - PresenterProtocol
protocol SignInPresenterLogic {
    func presentSignInSuccess(response: SignInModles.SignIn.Success)
    func presentSignInFailure(response: SignInModles.SignIn.Failure)
    func dismissAuthViewController()
}

//MARK: - ViewProtocol
protocol SignInViewLogic: AnyObject {
    func showAlert(message: String, completion: (() -> Void)?)
    func displaySignInFailure(viewModel: SignInModles.SignIn.ViewModelFailure)
}

protocol SignInWorkerLogic {
    func signIn(username: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void)
    func setUpTabBar()
}
