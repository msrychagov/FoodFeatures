import UIKit

//MARK: - BuisnessLogicProtocol
protocol SignUpBuisnessLogic {
    func registerUser(request: SignUp.registerUser.Request)
    func routeToProfile(request: SignUp.routeToProfile.Request)
    func handleSignUpResult(success: Bool, message: String)
}

//MARK: - PresenterProtocol
protocol SignUpPresenterLogic {
    func routeToProfile(response: SignUp.routeToProfile.Response)
    func checkFields(response: SignUp.checkField.Response)
    func showAlert(response: SignUp.showAlert.Response, completion: @escaping (() -> Void))
}

//MARK: - ViewProtocol
protocol SignUpViewLogic: AnyObject {
    func showAlert(message: String, completion: (() -> Void)?)
}
