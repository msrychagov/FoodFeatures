import UIKit

final class MarketsPresenter: MarketsPresenterLogic {
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: MarketsViewLogic?
    
    //MARK: - Methods
    func routeToCategories(response: Markets.RouteToCategories.Response) {
        response.navigationController?.pushViewController(CategoriesAssembly.build(market: response.market, chapter: response.chapter), animated: true)
    }
    
    func fetchMarkets(response: Markets.FetchMarkets.Response) {
        view?.fetchMarkets(viewModel: .init(markets: response.markets))
    }
}
