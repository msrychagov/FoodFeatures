import UIKit

final class SignInPresenter: SignInPresenterLogic {
    func showAlert(response: SignInModles.showAlert.Response, completion: @escaping (() -> Void)) {
        view?.showAlert(message: response.message, completion: completion)
    }
    
    func checkFields(response: SignInModles.checkFields.Response) {
        if (response.email.isEmpty || response.password.isEmpty) {
            view?.showAlert(message: "Введите почту или пароль", completion: nil)
        }
    }
    
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: SignInViewLogic?
    
    //MARK: - Methods
    func routeToProfile(response: SignInModles.routeToProfile.Response) {
        let tabBar = MainTabBarController()
        tabBar.selectedIndex = 0
        response.navigationController?.setViewControllers([tabBar], animated: true)
    }
    
    func presentSignInSuccess(response: SignInModles.SignIn.Response) {
            // Формируем ViewModel для успеха
            let viewModel = SignInModles.SignIn.ViewModelSuccess(
                token: response.token // если нужно отобразить
            )
            view?.displaySignInSuccess(viewModel: viewModel)
        }

        func presentSignInFailure(error: Error) {
            // Формируем ViewModel для ошибки
            let viewModel = SignInModles.SignIn.ViewModelFailure(
                errorMessage: error.localizedDescription
            )
            view?.displaySignInFailure(viewModel: viewModel)
        }
}
