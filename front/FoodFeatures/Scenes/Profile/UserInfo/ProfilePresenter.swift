import UIKit

final class ProfilePresenter: ProfilePresenterLogic {
    func routeToEditor(response: ProfileModels.RouteToEditor.Response) {
        response.navigationController?.pushViewController(EditorAssembly.build(user: response.user), animated: true)
    }
    
    func presentUserInfo(response: ProfileModels.FetchUserInfoSuccess.Response) {
        let name = response.user.name
        let email = response.user.email
        let preferences = response.user.preferences ?? []
        let viewModel = ProfileModels.FetchUserInfoSuccess.ViewModel(name: name, email: email, preferences: preferences)
        view?.displayUserInfo(viewModel: viewModel)
    }
    
    func presentError(response: ProfileModels.FetchUserInfoFailure.Response) {
        let errorMessage = response.error.localizedDescription
        view?.showAlert(viewModel: .init(errorMessage: errorMessage))
    }
    
    func presentGeneralAuth(response: ProfileModels.SignOut.Response) {
        response.navigationController?.present(GeneralAuthAssembly.build(), animated: true)
    }
    
    
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: ProfileViewLogic?
    
    //MARK: - Methods
    
}
