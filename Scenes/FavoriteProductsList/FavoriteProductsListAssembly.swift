import UIKit

enum FavoriteProductsListAssembly {
    static func build () -> UIViewController {
        let presenter = FavoriteProductsListPresenter()
        let interactor = FavoriteProductsListInteractor(presenter: presenter)
        let view = FavoriteProductsListViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
