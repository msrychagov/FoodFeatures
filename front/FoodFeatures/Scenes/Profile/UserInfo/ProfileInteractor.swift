import Foundation

final class ProfileInteractor: ProfileBuisnessLogic {
    func routeToEditor(request: ProfileModels.RouteToEditor.Request) {
        worker.fetchUserInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    let response = ProfileModels.RouteToEditor.Response(navigationController: request.navigationController, user: user)
                    self?.presenter.routeToEditor(response: response)
                case .failure(let error):
                    self?.presenter.presentError(response: .init(error: error))
                }
            }
        }
    }
    
    func signOut(request: ProfileModels.SignOut.Request) {
        worker.signOut()
        presenter.presentGeneralAuth(response: .init(navigationController: request.navigationController))
        worker.setUpTabBar()
    }
    
    func fetchUserInfo() {
        worker.fetchUserInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                    let response = ProfileModels.FetchUserInfoSuccess.Response(user: user)
                    self?.presenter.presentUserInfo(response: response)
                case .failure(let error):
                    let response = ProfileModels.FetchUserInfoFailure.Response(error: error)
                    self?.presenter.presentError(response: response)
                }
            }
        }
    }
    
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    private let presenter: ProfilePresenterLogic
    private lazy var worker: ProfileWorkerLogic = ProfileWorker(interactor: self)
    //MARK: - Lyfesycles
    init (presenter: ProfilePresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    
    
}
