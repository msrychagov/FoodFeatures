import UIKit

final class SignInPresenter: SignInPresenterLogic {
    //MARK: Variables
    weak var view: SignInViewLogic?
    
    //MARK: - Methods
    func presentSignInSuccess(response: SignInModles.SignIn.Success) {
        dismissAuthViewController()
    }
    
    func presentSignInFailure(response: SignInModles.SignIn.Failure) {
        // Формируем ViewModel для ошибки
        let viewModel = SignInModles.SignIn.ViewModelFailure(
            errorMessage: response.errorMessage
        )
        view?.displaySignInFailure(viewModel: viewModel)
    }
    
    func dismissAuthViewController() {
        let viewController = view as? SignInViewController
        viewController?.dismiss(animated: true)
    }
}
