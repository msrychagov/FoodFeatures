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
                    self!.checkRestrictions(product: product)
                case .failure(let error):
                    self!.presenter.presentScanFailure(error: error)
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
        getUser()
    }
    
    //MARK: Methods
    private func getUser() {
        AuthService().fetchCurrentUser(accessToken: AuthManager.shared.getToken()!) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    print("Говно: \(error)")
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
            let response = ScannedProductModels.LoadProduct.Response(scannedProductResponse: product, compatible: true)
            self.presenter.presentScanSuccess(response: response)
        case false:
            let response = ScannedProductModels.LoadProduct.Response(scannedProductResponse: product, compatible: false)
            self.presenter.presentScanSuccess(response: response)
        }
    }
}
