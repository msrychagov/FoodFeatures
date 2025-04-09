//MARK: - BuisnessLogicProtocol
protocol ScannedProductBuisnessLogic {
    func loadProduct()
    func goBackToScanner(request: ScannedProductModels.GoBackToScanner.Request)
}

//MARK: - PresenterProtocol
protocol ScannedProductPresenterLogic {
    func presentScanSuccess(response: ScannedProductModels.LoadProduct.Response)
    func presentScanFailure(error: String)
    func goBackToScanner(response: ScannedProductModels.GoBackToScanner.Response)
}

//MARK: - ViewProtocol
protocol ScannedProductViewLogic: AnyObject {
    func configure(viewModel: ScannedProductModels.LoadProduct.Success.ViewModel)
    func displayScanFailure(viewModel: ScannedProductModels.LoadProduct.Failure.ViewModel)
    func showAlert(message: String)
}

//MARK: - WorkerProtocol
protocol ScannedProductWorkerLogic {
    func loadProduct(barcode: String, completion: @escaping (Result<ScannedProductResponse, Error>) -> Void)
}
