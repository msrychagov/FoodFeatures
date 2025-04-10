import UIKit

final class ProductInfoPresenter: ProductInfoPresenterLogic {
    func presentGotImage(response: ProductInfoModels.SetImage.Response) {
        let viewModel = ProductInfoModels.SetImage.ViewModel(image: UIImage(data: response.data!))
        view?.displayGotImage(viewModel: viewModel)
    }
    
    func presentIsAuthed(response: ProductInfoModels.IsAuthed.Response) {
        view?.displayIsAuthed(viewModel: .init(isAuthed: response.isAuthed))
    }
    
    func presentIsFavorite(response: ProductInfoModels.IsFavorite.Response) {
        let viewModel = ProductInfoModels.IsFavorite.ViewModel(isFavorite: response.isFavorite)
        view?.displayIsFavorite(viewModel: viewModel)
    }
    
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
        let nsError = error as NSError
        let code = nsError.code
        let errorMessage = code == 401 ? "Чтобы добавить товар в избранное, нужно авторизоваться" : "Не удается получить ответ от сервера"
        let kind = code == 401 ? ProductInfoModels.ToggleFavorite.AlertViewModel.Kind.auth : ProductInfoModels.ToggleFavorite.AlertViewModel.Kind.server
        let alertModel = ProductInfoModels.ToggleFavorite.AlertViewModel(kind: kind, message: errorMessage)
        view?.displayToggleFavoriteFailure(viewModel: alertModel)
    }
    
    func presentAuth(response: ProductInfoModels.RouteToAuth.Response) {
        response.navigationController?.present(GeneralAuthAssembly.build(), animated: true)
    }
}
