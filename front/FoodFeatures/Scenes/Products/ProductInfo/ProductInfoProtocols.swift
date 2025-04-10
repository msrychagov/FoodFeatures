//MARK: - BuisnessLogicProtocol
import Foundation
protocol ProductInfoBuisnessLogic {
    func toggleFavorite(request: ProductInfoModels.ToggleFavorite.Request)
    func goAuth(request: ProductInfoModels.RouteToAuth.Request)
    func isFavorite(request: ProductInfoModels.IsFavorite.Request)
    func getImage(request: ProductInfoModels.SetImage.Request)
    func isAuthed()
}

//MARK: - PresenterProtocol
protocol ProductInfoPresenterLogic {
    func presentToggleFavoriteSuccess(response: ProductInfoModels.ToggleFavorite.Response)
    func presentToggleFavoriteFailure(error: Error)
    func presentIsFavorite(response: ProductInfoModels.IsFavorite.Response)
    func presentAuth(response: ProductInfoModels.RouteToAuth.Response)
    func presentIsAuthed(response: ProductInfoModels.IsAuthed.Response)
    func presentGotImage(response: ProductInfoModels.SetImage.Response)
}

//MARK: - ViewProtocol
protocol ProductInfoViewLogic: AnyObject {
    func displayToggleFavoriteFailure(viewModel: ProductInfoModels.ToggleFavorite.AlertViewModel)
    func displayToggleFavoriteSuccess(viewModel: ProductInfoModels.ToggleFavorite.ViewModelSuccess)
    func displayIsFavorite(viewModel: ProductInfoModels.IsFavorite.ViewModel)
    func displayIsAuthed(viewModel: ProductInfoModels.IsAuthed.ViewModel)
    func displayGotImage(viewModel: ProductInfoModels.SetImage.ViewModel)
}

protocol ProductInfoWorkerLogic {
    func addFavorite(productId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func removeFavorite(productId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func isLiked(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func isAuthed(completion: @escaping (Bool) -> Void)
    func downloadImage(url: URL, completion: @escaping (Data?) -> Void)
}
