import UIKit

enum GeneralAuthAssembly {
    static func build () -> UIViewController {
        let presenter = GeneralAuthPresenter()
        let interactor = GeneralAuthInteractor(presenter: presenter)
        let view = GeneralAuthViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
