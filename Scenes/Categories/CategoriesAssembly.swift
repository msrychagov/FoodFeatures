import UIKit

enum CategoriesAssembly {
    static func build (market: Market, chapter: String) -> UIViewController {
        let presenter = CategoriesPresenter()
        let interactor = CategoriesInteractor(presenter: presenter)
        let view = CategoriesViewController(interactor: interactor, market: market, chapter: chapter)
        presenter.view = view
        
        return view
    }
}
