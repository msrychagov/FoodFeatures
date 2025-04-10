//MARK: - BuisnessLogicProtocol
protocol ProfileBuisnessLogic {
    func signOut(request: ProfileModels.SignOut.Request)
    func fetchUserInfo()
    func routeToEditor(request: ProfileModels.RouteToEditor.Request)
}

//MARK: - PresenterProtocol
protocol ProfilePresenterLogic {
    func presentGeneralAuth(response: ProfileModels.SignOut.Response)
    func presentUserInfo(response: ProfileModels.FetchUserInfoSuccess.Response)
    func presentError(response: ProfileModels.FetchUserInfoFailure.Response)
    func routeToEditor(response: ProfileModels.RouteToEditor.Response)
}

//MARK: - ViewProtocol
protocol ProfileViewLogic: AnyObject {
    func displayUserInfo(viewModel: ProfileModels.FetchUserInfoSuccess.ViewModel)
    func showAlert(viewModel: ProfileModels.FetchUserInfoFailure.ViewModel)
}

//MARK: - WorkerProtocol
protocol ProfileWorkerLogic {
    func signOut()
    func setUpTabBar()
    func fetchUserInfo(completion: @escaping (Result<User, Error>) -> Void)
}
