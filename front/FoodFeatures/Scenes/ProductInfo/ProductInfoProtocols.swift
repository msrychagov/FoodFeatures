//MARK: - BuisnessLogicProtocol
protocol ProductInfoBuisnessLogic {
    func toggleFavorite(request: ProductInfoModels.ToggleFavorite.Request)
}

//MARK: - PresenterProtocol
protocol ProductInfoPresenterLogic {
    func presentToggleFavoriteSuccess(response: ProductInfoModels.ToggleFavorite.Response)
    func presentToggleFavoriteFailure(error: Error)
}

//MARK: - ViewProtocol
protocol ProductInfoViewLogic: AnyObject {
    func displayToggleFavoriteFailure(viewModel: ProductInfoModels.ToggleFavorite.ViewModelFailure)
    func displayToggleFavoriteSuccess(viewModel: ProductInfoModels.ToggleFavorite.ViewModelSuccess)
}

protocol ProductInfoWorkerLogic {
    func addFavorite(productId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func removeFavorite(productId: Int, completion: @escaping (Result<Void, Error>) -> Void)
}
