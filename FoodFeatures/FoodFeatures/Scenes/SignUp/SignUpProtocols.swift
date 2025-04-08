import UIKit

//MARK: - BuisnessLogicProtocol
protocol SignUpBuisnessLogic {
    func signUp(request: SignUpModels.SignUp.Request)
    func updatePreferences(request: SignUpModels.UpdatePrefernces.Request)
    func fetchPreferences()
    func routeToProfile(request: SignUpModels.routeToProfile.Request)
    func handleSignUpResult(success: Bool, message: String)
}

//MARK: - PresenterProtocol
protocol SignUpPresenterLogic {
    func routeToProfile(response: SignUpModels.routeToProfile.Response)
    func checkFields(response: SignUpModels.checkField.Response)
    func showAlert(response: SignUpModels.showAlert.Response, completion: @escaping (() -> Void))
    func presentFetchedPreferences(response: SignUpModels.UpdatePrefernces.Response)
    func presentSignUpSuccess(response: SignUpModels.SignUp.Response)
    func presentSignUpFailure(error: Error)
}

//MARK: - ViewProtocol
protocol SignUpViewLogic: AnyObject {
    func showAlert(message: String, completion: (() -> Void)?)
    func displaySignUpSuccess(viewModel: SignUpModels.SignUp.ViewModelSuccess)
    func displaySignUpFailure(viewModel: SignUpModels.SignUp.ViewModelFailure)
    func displayPreferences(viewModel: SignUpModels.UpdatePrefernces.ViewModel)
}

protocol SignUpWorkerLogic {
    func signUp(name: String, preferences: [String], email: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void)
}
