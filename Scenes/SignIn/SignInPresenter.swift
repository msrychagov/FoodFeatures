import UIKit

final class SignInPresenter: SignInPresenterLogic {
    func showAlert(response: SignIn.showAlert.Response, completion: @escaping (() -> Void)) {
        view?.showAlert(message: response.message, completion: completion)
    }
    
    func checkFields(response: SignIn.checkFields.Response) {
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
    func routeToProfile(response: SignIn.routeToProfile.Response) {
        response.navigationController?.pushViewController(ProfileAssembly.build(), animated: true)
    }
}
