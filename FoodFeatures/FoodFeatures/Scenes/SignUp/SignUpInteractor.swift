import UIKit

final class SignUpInteractor: SignUpBuisnessLogic {
    
    
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    private let presenter: SignUpPresenterLogic
    private lazy var worker: SignUpWorker = SignUpWorker(interactor: self)
    private var navigationController: UINavigationController?
    
    //MARK: - Lyfesycles
    init (presenter: SignUpPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    
    func signUp(request: SignUpModels.SignUp.Request) {
            worker.signUp(name: request.name, email: request.email, password: request.password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tokenResponse):
                        // Формируем Response, передаём токен
                        AuthManager.shared.saveToken(tokenResponse.access_token)
                        let response = SignUpModels.SignUp.Response(token: tokenResponse.access_token)
                        self?.presenter.presentSignUpSuccess(response: response)
                    case .failure(let error):
                        self?.presenter.presentSignUpFailure(error: error)
                    }
                }
            }
        }
    
    func routeToProfile(request: SignUpModels.routeToProfile.Request) {
        presenter.routeToProfile(response: SignUpModels.routeToProfile.Response(navigationController: request.navigationController))
    }
    func handleSignUpResult(success: Bool, message: String) {
        presenter.showAlert(response: SignUpModels.showAlert.Response(message: message)) {
            if success {
                self.presenter.routeToProfile(response: SignUpModels.routeToProfile.Response(navigationController: self.navigationController))
            }
        }
    }
}
