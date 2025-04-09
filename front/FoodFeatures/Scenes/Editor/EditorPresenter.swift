import UIKit

final class EditorPresenter: EditorPresenterLogic {
    
    func fetchPreferences(response: EditorModels.FetchPreferences.Response) {
        let viewModel = EditorModels.FetchPreferences.ViewModel(preferences: response.preferences)
        view?.displayPreferences(viewModel: viewModel)
    }
    
    func fetchUser(response: EditorModels.FetchUser.Response) {
        let viewModel = EditorModels.FetchUser.ViewModel(name: response.user.name, email: response.user.email, features: response.user.preferences!)
        view?.setUserValues(viewModel: viewModel)
        
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: EditorViewLogic?
    
    //MARK: - Methods
    
}
