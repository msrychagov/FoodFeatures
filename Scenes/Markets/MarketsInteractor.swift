final class MarketsInteractor: MarketsBuisnessLogic {
    func routeToCategories(request: Markets.routeToCategories.Request) {
        presenter.routeToCategories(response: Markets.routeToCategories.Response(navigationController: request.navigationController, market: request.market, chapter: request.chapter))
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: MarketsPresenterLogic
    
    //MARK: - Lyfesycles
    init (presenter: MarketsPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    
    
}
