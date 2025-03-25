import UIKit

enum AuthorizationAssembly {
    static func build () -> UIViewController {
        let presenter = AuthorizationPresenter()
        let interactor = AuthorizationInteractor(presenter: presenter)
        let view = AuthorizationViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
