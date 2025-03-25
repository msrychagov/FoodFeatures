import UIKit

enum FavoritesAssembly {
    static func build () -> UIViewController {
        let presenter = FavoritesPresenter()
        let interactor = FavoritesInteractor(presenter: presenter)
        let view = FavoritesViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
