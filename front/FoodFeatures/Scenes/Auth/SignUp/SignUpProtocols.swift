import UIKit

//MARK: - BuisnessLogicProtocol
protocol SignUpBuisnessLogic {
    func signUp(request: SignUpModels.SignUp.Request)
    func updatePreferences(request: SignUpModels.UpdatePrefernces.Request)
    func fetchPreferences()
//    func handleSignUpResult(success: Bool, message: String)
    func setUpTabBar()
    func showAlert(request: SignUpModels.ShowAlert.Request)
    func checkFields(request: SignUpModels.CheckFields.Request, completion: @escaping (Bool) -> Void)
}

//MARK: - PresenterProtocol
protocol SignUpPresenterLogic {
    func showAlert(response: SignUpModels.ShowAlert.Response)
    func presentFetchedPreferences(response: SignUpModels.UpdatePrefernces.Response)
    func presentSignUpSuccess(response: SignUpModels.SignUp.Response)
    func presentSignUpFailure(error: Error)
    func dismissAuthViewController()
}

//MARK: - ViewProtocol
protocol SignUpViewLogic: AnyObject {
    func displaySignUpSuccess(viewModel: SignUpModels.SignUp.ViewModelSuccess)
    func displaySignUpFailure(viewModel: SignUpModels.SignUp.ViewModelFailure)
    func displayPreferences(viewModel: SignUpModels.UpdatePrefernces.ViewModel)
}

protocol UserDataViewDelegate: AnyObject {
    func userDataView(type: String, text: String)
}

protocol SignUpWorkerLogic {
    func signUp(name: String, preferences: [String], email: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void)
    func setUpTabBar()
}


