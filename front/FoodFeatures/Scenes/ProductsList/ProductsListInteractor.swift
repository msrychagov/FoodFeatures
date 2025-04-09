import Foundation

final class ProductsListInteractor: ProductsBuisnessLogic {
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: ProductsPresenterLogic
    private lazy var worker: ProductsWorkerLogic = ProductsWorker(interactor: self)
    
    //MARK: - Lyfesycles
    init (presenter: ProductsPresenterLogic) {
        self.presenter = presenter
    }
    
    func loadProducts(request: ProductsModels.Load.Request) {
        worker.fetchProducts(storeId: request.storeId, categoryId: request.categoryId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let remoteProducts):
                    self?.presenter.presentProducts(response: ProductsModels.Load.Response(products: remoteProducts))
                case .failure(let error):
                    print("Ошибка загрузки с сервера: \(error)")
                }
            }
        }
    }
    
    func loadFavoriteProducts(request: ProductsModels.Load.Request) {
        worker.fetchFavoriteProducts(storeId: request.storeId, categoryId: request.categoryId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let remoteProducts):
                    self?.presenter.presentProducts(response: ProductsModels.Load.Response(products: remoteProducts))
                case .failure(let error):
                    print("Ошибка загрузки с сервера: \(error)")
                }
            }
        }
    }
}
