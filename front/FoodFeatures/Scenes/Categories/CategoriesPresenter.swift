import UIKit

final class CategoriesPresenter: CategoriesPresenterLogic {
    func presentDisplayedCategories(response: CategoriesModels.SetDisplayedCategories.Response) {
        let viewModel = CategoriesModels.SetDisplayedCategories.ViewModel(displayedCategories: response.categories)
        view?.displayCategories(viewModel: viewModel)
    }
    
    
    //MARK: Variables
    weak var view: CategoriesViewLogic?
    
    //MARK: - Methods
    func routeToProductsList(response: CategoriesModels.RouteToProductsList.Response) {
        let navigationController = response.navigationController
        let marketId = response.marketId
        let category = response.category
        let chapter = response.chapter
        let productsListVC = ProductsListAssembly.build(marketId: marketId, category: category, chapter: chapter)
        navigationController?.pushViewController(productsListVC, animated: true)
    }
}
