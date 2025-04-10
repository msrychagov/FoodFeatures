import UIKit

enum SignUpAssembly {
    static func build () -> UIViewController {
        let presenter = SignUpPresenter()
        let interactor = SignUpInteractor(presenter: presenter)
        let view = SignUpViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
