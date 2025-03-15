import UIKit

final class SignInPresenter: SignInPresenterLogic {
    
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
