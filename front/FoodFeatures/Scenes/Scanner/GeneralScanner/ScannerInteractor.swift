final class ScannerInteractor: ScannerBuisnessLogic {
    
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: ScannerPresenterLogic
    private var barcode: String = ""
    private lazy var worker: ScannerWorkerLogic = ScannerWorker(interactor: self)
    //MARK: - Lyfesycles
    init (presenter: ScannerPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    func startScanning(request: ScannerModels.Setup.Request) {
        worker.setupCaptureSession(in: request.view)
        worker.startCapture()
    }
    
    func resumeScanning() {
        worker.startCapture()
    }
    
    func didCaptureBarcode(_ code: String) {
        // Здесь можно добавить бизнес-логику:
        // проверка, обработка, принятие решения, дальнейшие действия
        print("Интерактор получил штрихкод: \(code)")
        barcode = code
        // Например, сообщить презентеру о результате или выполнить другие действия
        // Не забудьте остановить сканирование, если это требуется:
        presenter.scanSuccess()
        worker.stopCapture()
    }
    
    func routeToScannedProduct(request: ScannerModels.RouteToScannedProduct.Request) {
        let response = ScannerModels.RouteToScannedProduct.Response(navigationController: request.navigationController, barcode: self.barcode)
        presenter.routeToScannedProduct(response: response)
    }
    
}
