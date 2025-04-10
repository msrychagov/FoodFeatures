import Foundation
final class ProductInfoInteractor: ProductInfoBuisnessLogic {
    func getImage(request: ProductInfoModels.SetImage.Request) {
        guard let url = URL(string: request.product.image_url) else {
            return
        }
        worker.downloadImage(url: url) { [weak self] data in
            self?.presenter.presentGotImage(response: .init(data: data))
            
        }
    }
    
    func isAuthed() {
        worker.isAuthed { [weak self] authed in
            self?.presenter.presentIsAuthed(response: .init(isAuthed: authed))
        }
    }
    
    func isFavorite(request: ProductInfoModels.IsFavorite.Request) {
        let product = request.product
        worker.isLiked(productId: product.id!) { [weak self] result in
            switch result {
            case .success(let isLiked):
                self?.presenter.presentIsFavorite(response: ProductInfoModels.IsFavorite.Response(isFavorite: isLiked))
            case .failure(let error):
                self?.presenter.presentToggleFavoriteFailure(error: error)
        
            }
        }
    }
    
    func toggleFavorite(request: ProductInfoModels.ToggleFavorite.Request) {
        let product = request.product
        worker.isLiked(productId: product.id!) { [weak self] result in
            switch result {
            case .success(let isLiked):
                switch isLiked {
                case true:
                    self?.worker.removeFavorite(productId: product.id!) { [weak self] _ in
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name("FavoriteRemoved"), object: product)
                            self?.presenter.presentToggleFavoriteSuccess(response: .init(isFavoriteNow: false))
                        }
                }
                case false:
                    self?.worker.addFavorite(productId: product.id!) { [weak self] _ in
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name("FavoriteAdded"), object: product)
                            self?.presenter.presentToggleFavoriteSuccess(response: .init(isFavoriteNow: true))
                        }
                    }
                }
            case .failure(let error):
                self?.presenter.presentToggleFavoriteFailure(error: error)
            }
        }
    }
    
    func goAuth(request: ProductInfoModels.RouteToAuth.Request) {
        presenter.presentAuth(response: .init(navigationController: request.navigationController))
    }
    
    //MARK: Variables
    let presenter: ProductInfoPresenterLogic
    lazy var worker: ProductInfoWorker = ProductInfoWorker(interactor: self)
    
    //MARK: - Lyfesycles
    init (presenter: ProductInfoPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    
    
}
