import UIKit

final class ScannedProductPresenter: ScannedProductPresenterLogic {
    func loadSuccess(response: ScannedProductModels.LoadProduct.Response) {
        let product = response.scannedProductResponse.product
        let viewModel = ScannedProductModels.LoadProduct.Success.ViewModel(productName: product.product_name!, brand: product.brands!)
        view?.configure(viewModel: viewModel)
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: ScannedProductViewLogic?
    
    //MARK: - Methods
    
}
