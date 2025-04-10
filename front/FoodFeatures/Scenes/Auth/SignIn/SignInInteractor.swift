import UIKit

final class SignInInteractor: SignInBuisnessLogic {
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: SignInPresenterLogic
    private lazy var worker: SignInWorker = SignInWorker(interactor: self)
    private var navigationController: UINavigationController?
    
    //MARK: - Lyfesycles
    init (presenter: SignInPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    
    func signIn(request: SignInModles.SignIn.Request) {        guard !request.username.isEmpty && !request.password.isEmpty else {
            let response = SignInModles.SignIn.Failure(errorMessage: "Заполните все данные")
            presenter.presentSignInFailure(response: response)
            return
        }
        
        worker.signIn(username: request.username, password: request.password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tokenResponse):
                        AuthManager.shared.saveToken(tokenResponse.access_token)
                        self?.worker.setUpTabBar()
                        self?.presenter.presentSignInSuccess(response: SignInModles.SignIn.Success())
                    case .failure(let error):
                        self?.presenter.presentSignInFailure(response: SignInModles.SignIn.Failure(errorMessage: error.localizedDescription))
                    }
                }
            }
        }
}
