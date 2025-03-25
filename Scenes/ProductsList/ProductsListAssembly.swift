import UIKit

enum ProductsListAssembly {
    static func build (marketId: Int, categoryId: Int, chapter: String) -> UIViewController {
        let presenter = ProductsListPresenter()
        let interactor = ProductsListInteractor(presenter: presenter)
        let view = ProductsListViewController(interactor: interactor, marketId: marketId, categoryId: categoryId, chapter: chapter)
        presenter.view = view
        
        return view
    }
}
