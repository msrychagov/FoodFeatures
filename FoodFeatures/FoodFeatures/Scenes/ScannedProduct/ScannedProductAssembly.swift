import UIKit

enum ScannedProductAssembly {
    static func build (barcode: String) -> UIViewController {
        let presenter = ScannedProductPresenter()
        let interactor = ScannedProductInteractor(presenter: presenter, barcode: barcode)
        let view = ScannedProductViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
