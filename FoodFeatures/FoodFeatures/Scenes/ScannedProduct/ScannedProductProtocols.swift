//MARK: - BuisnessLogicProtocol
protocol ScannedProductBuisnessLogic {
    func loadProduct()
}

//MARK: - PresenterProtocol
protocol ScannedProductPresenterLogic {
    func loadSuccess(response: ScannedProductModels.LoadProduct.Response)
}

//MARK: - ViewProtocol
protocol ScannedProductViewLogic: AnyObject {
    func configure(viewModel: ScannedProductModels.LoadProduct.Success.ViewModel)
}

//MARK: - WorkerProtocol
protocol ScannedProductWorkerLogic {
    func loadProduct(barcode: String, completion: @escaping (Result<ScannedProductResponse, Error>) -> Void)
}
