import Foundation

final class ScannedProductInteractor: ScannedProductBuisnessLogic {
    func loadProduct() {
        worker.loadProduct(barcode: barcode) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let product):
                    let response = ScannedProductModels.LoadProduct.Response(scannedProductResponse: product)
                    self!.presenter.loadSuccess(response: response)
                    print(product.product)
                case .failure(let error):
                    print("Ебаный штрихкод")
                }
            }
        }
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: ScannedProductPresenterLogic
    let barcode: String
    private lazy var worker: ScannedProductWorkerLogic = ScannedProductWorker(interactor: self)
    //MARK: - Lyfesycles
    init (presenter: ScannedProductPresenterLogic, barcode: String) {
        self.presenter = presenter
        self.barcode = barcode
        print(barcode)
    }
    
    //MARK: Methods
    
    
    
}
