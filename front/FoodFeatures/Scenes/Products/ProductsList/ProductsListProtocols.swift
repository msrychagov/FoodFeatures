//MARK: - BuisnessLogicProtocol
protocol ProductsBuisnessLogic {
    func loadProducts(request: ProductsModels.Load.Request)
    func loadFavoriteProducts(request: ProductsModels.Load.Request)
    func routeToProductInfo(request: ProductsModels.RouteToProductInfo.Request)
}

//MARK: - PresenterProtocol
protocol ProductsPresenterLogic {
    func presentProducts(response: ProductsModels.Load.Response)
    func presentError(error: Error)
    func presentProductInfo(response: ProductsModels.RouteToProductInfo.Response)
}

//MARK: - ViewProtocol
protocol ProductsListViewLogic: AnyObject {
    func displayProducts(viewModel: ProductsModels.Load.ViewModel)
    func displayError(message: String)
}

protocol ProductsWorkerLogic {
    func fetchProducts(storeId: Int, categoryId: Int, completion: @escaping (Result<[Product], Error>) -> Void)
    func fetchFavoriteProducts(storeId: Int, categoryId: Int, completion: @escaping (Result<[Product], Error>) -> Void)
}
