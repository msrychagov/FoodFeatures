import UIKit

enum MarketsAssembly {
    static func build () -> UIViewController {
        let presenter = MarketsPresenter()
        let interactor = MarketsInteractor(presenter: presenter)
        let view = MarketsViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
