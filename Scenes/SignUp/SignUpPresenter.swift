import UIKit

final class SignUpPresenter: SignUpPresenterLogic {
    
    
    func checkFields(response: SignUp.checkField.Response) {
        if response.name.isEmpty ||
            response.age.isEmpty ||
            response.sex.isEmpty ||
            response.preferences.isEmpty ||
            response.email.isEmpty ||
            response.password.isEmpty {
            
            view?.showAlert(message: "Заполните все поля!", completion: nil)
        }
        
    }
    
    func showAlert(response: SignUp.showAlert.Response, completion: @escaping (() -> Void)) {
        view?.showAlert(message: response.message, completion: completion)
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: SignUpViewLogic?
    
    //MARK: - Methods
    func routeToProfile(response: SignUp.routeToProfile.Response) {
        response.navigationController?.pushViewController(ProfileAssembly.build(), animated: true)
    }
    
}
