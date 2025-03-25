import Foundation
final class ProductInfoInteractor: ProductInfoBuisnessLogic {
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: ProductInfoPresenterLogic
    lazy var worker: ProductInfoWorker = ProductInfoWorker(interactor: self)
    
    //MARK: - Lyfesycles
    init (presenter: ProductInfoPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    func toggleFavorite(request: ProductInfoModels.ToggleFavorite.Request) {
            if request.isCurrentlyFavorite {
                // Удаляем из избранного
                worker.removeFavorite(productId: request.productId) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            NotificationCenter.default.post(
                                name: Notification.Name("FavoriteRemoved"),
                                object: nil,
                                userInfo: ["productId": request.productId]
                            )
                            
                            let response = ProductInfoModels.ToggleFavorite.Response(isFavoriteNow: false)
                            self?.presenter.presentToggleFavoriteSuccess(response: response)
                        case .failure(let error):
                            self?.presenter.presentToggleFavoriteFailure(error: error)
                        }
                    }
                }
            } else {
                // Добавляем в избранное
                worker.addFavorite(productId: request.productId) { [weak self] result in
                    switch result {
                    case .success:
                        NotificationCenter.default.post(
                            name: Notification.Name("FavoriteAdded"),
                            object: nil,
                            userInfo: ["productId": request.productId]
                        )
                        
                        let response = ProductInfoModels.ToggleFavorite.Response(isFavoriteNow: true)
                        self?.presenter.presentToggleFavoriteSuccess(response: response)
                    case .failure(let error):
                        self?.presenter.presentToggleFavoriteFailure(error: error)
                    }
                }
            }
        }
    
}
