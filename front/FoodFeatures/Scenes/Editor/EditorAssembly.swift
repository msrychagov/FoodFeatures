import UIKit

enum EditorAssembly {
    static func build (user: User) -> UIViewController {
        let presenter = EditorPresenter()
        let interactor = EditorInteractor(presenter: presenter, user: user)
        let view = EditorViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
