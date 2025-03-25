import UIKit

final class FavoriteProductsListViewController: UIViewController, FavoriteProductsListViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    //MARK: - Variables
    private let interactor: FavoriteProductsListBuisnessLogic
    
    //MARK: Lyfecycles
    init (interactor: FavoriteProductsListBuisnessLogic) {
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
