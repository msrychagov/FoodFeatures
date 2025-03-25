import UIKit

final class MarketsPresenter: MarketsPresenterLogic {
    func routeToCategories(response: Markets.routeToCategories.Response) {
        response.navigationController?.pushViewController(CategoriesAssembly.build(market: response.market, chapter: response.chapter), animated: true)
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: MarketsViewLogic?
    
    //MARK: - Methods
    
}
