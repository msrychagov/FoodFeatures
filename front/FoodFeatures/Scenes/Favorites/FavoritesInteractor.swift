final class FavoritesInteractor: FavoritesBuisnessLogic {
    //MARK: Variables
    let presenter: FavoritesPresenterLogic
    private let markets: [Market] = [
            Market(title: "Перекрёсток", image: "perekrestokFavorite", id: 1),
            Market(title: "Лента", image: "lentaFavorite", id: 2),
            Market(title: "Магнит", image: "magnitFavorite", id: 3)]
    //MARK: - Lyfesycles
    init (presenter: FavoritesPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    func setMarkets(request: Favorites.Markets.Request) {
        let response = Favorites.Markets.Response(markets: markets)
        presenter.presentSetMarkets(response: response)
    }
    
    func routeToCategories(request: Favorites.RouteToCategories.Request) {
        let response = Favorites.RouteToCategories.Response(navigationController: request.navigationController, market: request.market, chapter: request.chapter)
        presenter.routeToCategories(response: response)
    }
}
