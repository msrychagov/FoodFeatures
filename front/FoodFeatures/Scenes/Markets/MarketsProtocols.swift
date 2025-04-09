//MARK: - BuisnessLogicProtocol
protocol MarketsBuisnessLogic {
    func routeToCategories(request: Markets.routeToCategories.Request)
}

//MARK: - PresenterProtocol
protocol MarketsPresenterLogic {
    func routeToCategories(response: Markets.routeToCategories.Response)
}

//MARK: - ViewProtocol
protocol MarketsViewLogic: AnyObject {
    
}
