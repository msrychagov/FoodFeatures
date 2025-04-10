import UIKit

enum ProductsListAssembly {
    static func build (marketId: Int, category: Category, chapter: String) -> UIViewController {
        let presenter = ProductsListPresenter()
        let interactor = ProductsListInteractor(presenter: presenter)
        let view = ProductsListViewController(interactor: interactor, marketId: marketId, category: category, chapter: chapter)
        presenter.view = view
        
        return view
    }
}
