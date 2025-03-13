import UIKit

final class SignUpViewController: UIViewController, SignUpViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    //MARK: - Variables
    private let interactor: SignUpBuisnessLogic
    
    //MARK: Lyfecycles
    init (interactor: SignUpBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {

    }
        
    //MARK: - Actions
}
