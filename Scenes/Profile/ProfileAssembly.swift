import UIKit

enum ProfileAssembly {
    static func build () -> UIViewController {
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(presenter: presenter)
        let view = ProfileViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
