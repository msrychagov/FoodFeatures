import UIKit

final class SignUpPresenter: SignUpPresenterLogic {
    
    
    func checkFields(response: SignUpModels.checkField.Response) {
        if response.name.isEmpty ||
            response.age.isEmpty ||
            response.sex.isEmpty ||
            response.preferences.isEmpty ||
            response.email.isEmpty ||
            response.password.isEmpty {
            
            view?.showAlert(message: "Заполните все поля!", completion: nil)
        }
        
    }
    
    func showAlert(response: SignUpModels.showAlert.Response, completion: @escaping (() -> Void)) {
        view?.showAlert(message: response.message, completion: completion)
    }
    
    //MARK: - Constants
    enum Constants {
        
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
    
    func routeToProfile(response: SignUpModels.routeToProfile.Response) {
        let tabBar = MainTabBarController()
        tabBar.selectedIndex = 0
        response.navigationController?.setViewControllers([tabBar], animated: true)
    }
    
}
