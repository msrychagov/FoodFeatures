import UIKit

enum SignInAssembly {
    static func build () -> UIViewController {
        let presenter = SignInPresenter()
        let interactor = SignInInteractor(presenter: presenter)
        let view = SignInViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
