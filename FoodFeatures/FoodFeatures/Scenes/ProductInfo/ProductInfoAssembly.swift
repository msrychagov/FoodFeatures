import UIKit

enum ProductInfoAssembly {
    static func build (product: Product) -> UIViewController {
        let presenter = ProductInfoPresenter()
        let interactor = ProductInfoInteractor(presenter: presenter)
        let view = ProductInfoViewController(interactor: interactor, product: product)
        presenter.view = view
        
        return view
    }
}
