import UIKit

final class ProductsListPresenter: ProductsPresenterLogic {
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: ProductsListViewLogic?
    
    //MARK: - Methods
    func presentProducts(response: ProductsModels.Load.Response) {
        let viewModel = ProductsModels.Load.ViewModel(displayedProducts: response.products)
        view?.displayProducts(viewModel: viewModel)
    }
    
    func presentError(error: Error) {
        view?.displayError(message: error.localizedDescription)
    }
}
