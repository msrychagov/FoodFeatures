import UIKit

enum UnAuthorizedUserAssembly {
    static func build () -> UIViewController {
        let presenter = UnAuthorizedUserPresenter()
        let interactor = UnAuthorizedUserInteractor(presenter: presenter)
        let view = UnAuthorizedUserViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
