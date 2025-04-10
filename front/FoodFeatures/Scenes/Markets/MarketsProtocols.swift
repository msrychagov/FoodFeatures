//MARK: - BuisnessLogicProtocol
protocol MarketsBuisnessLogic {
    func routeToCategories(request: Markets.RouteToCategories.Request)
    func fetchMarkets(request: Markets.FetchMarkets.Request)
}

//MARK: - PresenterProtocol
protocol MarketsPresenterLogic {
    func routeToCategories(response: Markets.RouteToCategories.Response)
    func fetchMarkets(response: Markets.FetchMarkets.Response)
}

//MARK: - ViewProtocol
protocol MarketsViewLogic: AnyObject {
    func fetchMarkets(viewModel: Markets.FetchMarkets.ViewModel)
}
