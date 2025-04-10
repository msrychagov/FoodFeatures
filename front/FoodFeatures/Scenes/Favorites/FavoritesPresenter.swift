import UIKit

final class FavoritesPresenter: FavoritesPresenterLogic {
    //MARK: Variables
    weak var view: FavoritesViewLogic?
    
    //MARK: - Methods
    func presentSetMarkets(response: Favorites.Markets.Response) {
        let viewModel = Favorites.Markets.ViewModel(markets: response.markets)
        view?.displayMarkets(viewModel: viewModel)
    }
    
    func routeToCategories(response: Favorites.RouteToCategories.Response) {
        response.navigationController?.pushViewController(CategoriesAssembly.build(market: response.market, chapter: response.chapter), animated: true)
    }
}
