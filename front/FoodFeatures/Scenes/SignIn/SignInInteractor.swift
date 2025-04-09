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
    
    func signIn(request: SignInModles.SignIn.Request) {
            // Вызываем worker (сеть/база/сервисы)
        worker.signIn(username: request.username, password: request.password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tokenResponse):
                        // Создаём Response для Presenter’а
                        AuthManager.shared.saveToken(tokenResponse.access_token)
                        let response = SignInModles.SignIn.Response(
                            token: tokenResponse.access_token // например, берем access_token
                        )
                        self?.presenter.presentSignInSuccess(response: response)

                    case .failure(let error):
                        self?.presenter.presentSignInFailure(error: error)
                    }
                }
            }
        }
    func routeToProfile(request: SignInModles.routeToProfile.Request) {
        presenter.routeToProfile(response: SignInModles.routeToProfile.Response(navigationController: request.navigationController))
    }
    
    func handleSignInResul(success: Bool, message: String) {
        presenter.showAlert(response: SignInModles.showAlert.Response(message: message)){
            if success {
                self.presenter.routeToProfile(response: SignInModles.routeToProfile.Response(navigationController: self.navigationController))
            }
        }
    }
    
//    func authUser(request: SignInModles.authUser.Request) {
//        navigationController = request.navigationController
//        presenter.checkFields(response: SignIn.checkFields.Response(email: request.email, password: request.password))
//        worker.signIn(email: request.email, password: request.password)
//    }
    
}
