import UIKit

final class UnAuthorizedUserPresenter: UnAuthorizedUserPresenterLogic {
    func routeToAuth(response: UnAuthorizedUser.RouteToAuth.Response) {
        response.navigationController.present(AuthAssembly.build(), animated: true)
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: UnAuthorizedUserViewLogic?
    
    //MARK: - Methods
    
}
