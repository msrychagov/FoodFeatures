final class CategoriesInteractor: CategoriesBuisnessLogic {
    func setDisplayedCategories(request: CategoriesModels.SetDisplayedCategories.Request) {
        let response = CategoriesModels.SetDisplayedCategories.Response(categories: self.categories)
        presenter.presentDisplayedCategories(response: response)
    }
    
    func routeToProductsList(request: CategoriesModels.RouteToProductsList.Request) {
        let navigationController = request.navigationController
        let marketId = request.marketId
        let category = request.category
        let chapter = request.chapter
        let response = CategoriesModels.RouteToProductsList.Response(navigationController: navigationController, marketId: marketId, category: category, chapter: chapter)
        presenter.routeToProductsList(response: response)
        
    }
    
    //MARK: Variables
    let presenter: CategoriesPresenterLogic
    private let categories: [Category] = [
            Category(title: "Без лактозы", image: "noLactose", id: 1),
            Category(title: "Без глютена", image: "noGluten", id: 2),
            Category(title: "Без орехов", image: "noNuts", id: 3),
            Category(title: "Без арахиса", image: "noPeanuts", id: 4),
            Category(title: "Без сезама", image: "noSesame", id: 5),
            Category(title: "Без сои", image: "noSoy", id: 6),
            Category(title: "Без сельдерея", image: "noCelery", id: 7),
            Category(title: "Без горчицы", image: "noMustard", id: 8),
            Category(title: "Без люпина", image: "noLupin", id: 9),
            Category(title: "Без рыбы", image: "noFish", id: 10),
            Category(title: "Без ракообразных", image: "noCrustaceans", id: 11),
            Category(title: "Без моллюсков", image: "noMollusks", id: 12),
        ]
    
    //MARK: - Lyfesycles
    init (presenter: CategoriesPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    
    
}
