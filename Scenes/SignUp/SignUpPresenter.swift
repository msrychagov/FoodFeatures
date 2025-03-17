import UIKit

final class SignUpPresenter: SignUpPresenterLogic {
    
    
    func checkFields(response: SignUp.checkField.Response) {
        if response.nameView.textField.text!.isEmpty ||
            response.ageView.textField.text!.isEmpty ||
            response.sexView.textField.text!.isEmpty ||
            response.preferencesView.textField.text!.isEmpty ||
            response.emailView.textField.text!.isEmpty ||
            response.passwordView.textField.text!.isEmpty {
            
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
