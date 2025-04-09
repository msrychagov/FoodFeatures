import UIKit

enum ScannerAssembly {
    static func build () -> UIViewController {
        let presenter = ScannerPresenter()
        let interactor = ScannerInteractor(presenter: presenter)
        let view = ScannerViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
