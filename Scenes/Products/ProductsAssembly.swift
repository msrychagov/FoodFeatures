import UIKit

enum ProductsAssembly {
    static func build () -> UIViewController {
        let presenter = ProductsPresenter()
        let interactor = ProductsInteractor(presenter: presenter)
        let view = ProductsViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
