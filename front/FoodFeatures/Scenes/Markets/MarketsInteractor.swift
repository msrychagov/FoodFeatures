final class MarketsInteractor: MarketsBuisnessLogic {
    //MARK: Variables
    let presenter: MarketsPresenterLogic
    private let markets = [
        Market(title: "Перекрёсток", image: "perekrestok", id: 1),
        Market(title: "Лента", image: "lenta", id: 2),
        Market(title: "Магнит", image: "magnit", id: 3)]
    //MARK: - Lyfesycles
    init (presenter: MarketsPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    func routeToCategories(request: Markets.RouteToCategories.Request) {
        presenter.routeToCategories(response: Markets.RouteToCategories.Response(navigationController: request.navigationController, market: request.market, chapter: request.chapter))
    }
    
    func fetchMarkets(request: Markets.FetchMarkets.Request) {
        presenter.fetchMarkets(response: .init(markets: markets))
    }
    
}
