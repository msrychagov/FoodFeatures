import UIKit

//MARK: - BuisnessLogicProtocol
protocol ScannerBuisnessLogic {
    func startScanning(request: ScannerModels.Setup.Request)
    func resumeScanning()
    func didCaptureBarcode(_ code: String)
    func routeToScannedProduct(request: ScannerModels.RouteToScannedProduct.Request)
}

//MARK: - PresenterProtocol
protocol ScannerPresenterLogic {
    func routeToScannedProduct(response: ScannerModels.RouteToScannedProduct.Response)
    func scanSuccess()
}

//MARK: - WorkerProtocol
protocol ScannerWorkerLogic {
    func setupCaptureSession(in view: UIView)
    func startCapture()
    func stopCapture()
}

//MARK: - ViewProtocol
protocol ScannerViewLogic: AnyObject {
    func scanSuccess()
}
