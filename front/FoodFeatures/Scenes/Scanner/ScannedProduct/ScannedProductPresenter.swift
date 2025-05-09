import UIKit

final class ScannedProductPresenter: ScannedProductPresenterLogic {
    func goBackToScanner(response: ScannedProductModels.GoBackToScanner.Response) {
        response.navigationController!.popViewController(animated: true)
    }
    
    func presentScanFailure(error: String) {
        let viewModel = ScannedProductModels.LoadProduct.Failure.ViewModel(errorMessage: error)
        view?.displayScanFailure(viewModel: viewModel)
    }
    
    func presentScanSuccess(response: ScannedProductModels.LoadProduct.Response) {
        let product = response.scannedProductResponse.product
        let compatible = response.compatible
        let auth = response.auth
        let allergensArray = getAllergenArray(allergensStringArray: product.allergens_tags ?? [])
        var message: String
        
        switch auth {
        case true:
            switch compatible {
            case true: message = "Продукт вам не подходит"
            case false: message = "Продукт вам подходит"
            }
        case false:
            message = "Вы не авторизованы"
        }
        
        let viewModel = ScannedProductModels.LoadProduct.Success.ViewModel(
            productName: product.product_name ?? "Без названия",
            brand: product.brands ?? "Без бренда",
            allergens: allergensArray,
            traces: product.traces_tags ?? [],
            message: message
        )
        view?.configure(viewModel: viewModel)
    }
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: ScannedProductViewLogic?
    
    //MARK: - Methods
    private func getAllergenArray(allergensStringArray: [String]) -> [Allergen] {
        var allergens: [Allergen] = []
        if allergensStringArray.count > 0 {
            for i in 0...allergensStringArray.count - 1 {
                allergens.append(Allergen(text: allergensStringArray[i], imageString: allergensStringArray[i]))
            }
        }
        return allergens
    }
}
