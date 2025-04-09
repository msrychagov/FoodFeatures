import UIKit

final class ScannerPresenter: ScannerPresenterLogic {
    func scanSuccess() {
        view?.scanSuccess()
    }
    
    func routeToScannedProduct(response: ScannerModels.RouteToScannedProduct.Response) {
        response.navigationController.pushViewController(ScannedProductAssembly.build(barcode: response.barcode), animated: true)
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: ScannerViewLogic?
    
    //MARK: - Methods
    
}
