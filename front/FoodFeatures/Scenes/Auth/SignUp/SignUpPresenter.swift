import UIKit

final class SignUpPresenter: SignUpPresenterLogic {
    func dismissAuthViewController() {
        let currentView = view as? SignUpViewController
        currentView!.dismiss(animated: true)
    }
    
    func presentFetchedPreferences(response: SignUpModels.UpdatePrefernces.Response) {
        let viewModel = SignUpModels.UpdatePrefernces.ViewModel(preferences: response.preferences)
        view?.displayPreferences(viewModel: viewModel)
    }
    
    func showAlert(response: SignUpModels.ShowAlert.Response) {
        let alert = UIAlertController(title: "Ошибка", message: response.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        let currentView = self.view as? SignUpViewController
        currentView!.present(alert, animated: true)
    }
    
    
    //MARK: Variables
    weak var view: SignUpViewLogic?
    
    //MARK: - Methods
    
    func presentSignUpSuccess(response: SignUpModels.SignUp.Response) {
        let viewModel = SignUpModels.SignUp.ViewModelSuccess(token: response.token)
        view?.displaySignUpSuccess(viewModel: viewModel)
    }
    
    func presentSignUpFailure(error: Error) {
        let viewModel = SignUpModels.SignUp.ViewModelFailure(errorMessage: error.localizedDescription)
        view?.displaySignUpFailure(viewModel: viewModel)
    }
    
}
