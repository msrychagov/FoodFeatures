//MARK: - BuisnessLogicProtocol
protocol FavoritesBuisnessLogic {
    func setMarkets(request: Favorites.Markets.Request)
    func routeToCategories(request: Favorites.RouteToCategories.Request)
}

//MARK: - PresenterProtocol
protocol FavoritesPresenterLogic {
    func presentSetMarkets(response: Favorites.Markets.Response)
    func routeToCategories(response: Favorites.RouteToCategories.Response)
}

//MARK: - ViewProtocol
protocol FavoritesViewLogic: AnyObject {
    func displayMarkets(viewModel: Favorites.Markets.ViewModel)
}
