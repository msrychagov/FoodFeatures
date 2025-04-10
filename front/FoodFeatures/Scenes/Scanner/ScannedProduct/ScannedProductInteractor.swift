import Foundation

final class ScannedProductInteractor: ScannedProductBuisnessLogic {
    func goBackToScanner(request: ScannedProductModels.GoBackToScanner.Request) {
        presenter.goBackToScanner(response: ScannedProductModels.GoBackToScanner.Response(navigationController: request.navigationController))
    }
    
    func loadProduct() {
        worker.loadProduct(barcode: barcode) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let product):
                    if AuthManager.shared.isLoggedIn() {
                    
                        self?.getUser() { user in
                            self?.user = user
                            self?.checkRestrictions(product: product)
                        }
                    } else {
                        let response = ScannedProductModels.LoadProduct.Response(scannedProductResponse: product, compatible: true, auth: false)
                        self?.presenter.presentScanSuccess(response: response)
                    }
                case .failure(let error):
                    self!.presenter.presentScanFailure(error: "Продукт не найден")
                }
            }
        }
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: ScannedProductPresenterLogic
    let barcode: String
    var user: User?
    var intersection: [String] = []
    private lazy var worker: ScannedProductWorkerLogic = ScannedProductWorker(interactor: self)
    //MARK: - Lyfesycles
    init (presenter: ScannedProductPresenterLogic, barcode: String) {
        self.presenter = presenter
        self.barcode = barcode
    }
    
    //MARK: Methods
    private func getUser(completion: @escaping (User?) -> Void) {
        CurrentUserService().fetchCurrentUser(accessToken: AuthManager.shared.getToken()!) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        completion(user)
                    case .failure(let error):
                        print("Говно: \(error)")
                        completion(nil)
                    }
                }
            }
    }
    
    private func checkRestrictions(product: ScannedProductResponse) {
        let allergens = product.product.allergens_tags!
        let userRestrictions = self.user?.preferences?.map { $0.lowercased() } ?? []
        let intersectionSet = Set(allergens).intersection(userRestrictions)
        switch intersectionSet.isEmpty {
            case true:
            let response = ScannedProductModels.LoadProduct.Response(scannedProductResponse: product, compatible: false, auth: true)
            self.presenter.presentScanSuccess(response: response)
        case false:
            let response = ScannedProductModels.LoadProduct.Response(scannedProductResponse: product, compatible: true, auth: true)
            self.presenter.presentScanSuccess(response: response)
        }
    }
}
