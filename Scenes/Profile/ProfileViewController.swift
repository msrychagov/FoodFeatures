import UIKit

final class ProfileViewController: UIViewController, ProfileViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    //MARK: - Variables
    private let interactor: ProfileBuisnessLogic
    
    //MARK: Lyfecycles
    init (interactor: ProfileBuisnessLogic) {
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
