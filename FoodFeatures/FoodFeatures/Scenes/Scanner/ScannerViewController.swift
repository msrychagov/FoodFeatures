import UIKit
import AVFoundation

final class ScannerViewController: UIViewController, ScannerViewLogic {
    func scanSuccess() {
        let request = ScannerModels.RouteToScannedProduct.Request(navigationController: self.navigationController!)
        interactor.routeToScannedProduct(request: request)
    }
    
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    //MARK: - Variables
    private let interactor: ScannerBuisnessLogic
    private var barcode: String = ""
    
    //MARK: Lyfecycles
    init (interactor: ScannerBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = ScannerModels.Setup.Request(view: view)
        interactor.startScanning(request: request)
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.resumeScanning()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        previewLayer?.frame = view.bounds
//    }
    
    private func configureUI() {
        
    }
}
