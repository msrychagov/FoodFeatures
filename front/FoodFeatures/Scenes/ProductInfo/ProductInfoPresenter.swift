import UIKit

final class ProductInfoPresenter: ProductInfoPresenterLogic {
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: ProductInfoViewLogic?
    
    //MARK: - Methods
    func presentToggleFavoriteSuccess(response: ProductInfoModels.ToggleFavorite.Response) {
        DispatchQueue.main.async {
            let viewModel = ProductInfoModels.ToggleFavorite.ViewModelSuccess(
                isFavoriteNow: response.isFavoriteNow
            )
            self.view?.displayToggleFavoriteSuccess(viewModel: viewModel)
        }
        }

        func presentToggleFavoriteFailure(error: Error) {
            DispatchQueue.main.async {
                let viewModel = ProductInfoModels.ToggleFavorite.ViewModelFailure(
                    errorMessage: error.localizedDescription
                )
                self.view?.displayToggleFavoriteFailure(viewModel: viewModel)
            }
        }
}
