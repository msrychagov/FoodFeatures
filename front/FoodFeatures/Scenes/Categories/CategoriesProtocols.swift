//MARK: - BuisnessLogicProtocol
protocol CategoriesBuisnessLogic {
    func routeToProductsList(request: CategoriesModels.RouteToProductsList.Request)
    func setDisplayedCategories(request: CategoriesModels.SetDisplayedCategories.Request)
}

//MARK: - PresenterProtocol
protocol CategoriesPresenterLogic {
    func routeToProductsList(response: CategoriesModels.RouteToProductsList.Response)
    func presentDisplayedCategories(response: CategoriesModels.SetDisplayedCategories.Response)
}

//MARK: - ViewProtocol
protocol CategoriesViewLogic: AnyObject {
    func displayCategories(viewModel: CategoriesModels.SetDisplayedCategories.ViewModel)
}
