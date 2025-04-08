import UIKit

enum AuthAssembly {
    static func build () -> UIViewController {
        let presenter = AuthPresenter()
        let interactor = AuthInteractor(presenter: presenter)
        let view = AuthViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
