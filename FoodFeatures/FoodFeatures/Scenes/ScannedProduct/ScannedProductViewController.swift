import UIKit

final class ScannedProductViewController: UIViewController, ScannedProductViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    //MARK: - Variables
    private let interactor: ScannedProductBuisnessLogic
    private let titleLabel: UILabel = UILabel()
    private let brandLabel: UILabel = UILabel()
    
    //MARK: Lyfecycles
    init (interactor: ScannedProductBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        super.viewDidLoad()
        interactor.loadProduct()
        configureUI()
    }
    
    func configure(viewModel: ScannedProductModels.LoadProduct.Success.ViewModel) {
        titleLabel.text = viewModel.productName
        brandLabel.text = viewModel.brand
    }
    private func configureUI() {
        configureTitleLabel()
        configureBrandLabel()
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        titleLabel.numberOfLines = 4
        view.addSubview(titleLabel)
        titleLabel.pinCenterX(to: view)
        titleLabel.pinCenterY(to: view)
        titleLabel.pinHorizontal(to: view, 20)
    }
    
    private func configureBrandLabel() {
        brandLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        brandLabel.numberOfLines = 2
        view.addSubview(brandLabel)
        brandLabel.pinCenterX(to: view)
        brandLabel.pinTop(to: titleLabel.bottomAnchor, 10)
        brandLabel.pinHorizontal(to: view, 20)
    }
    
        
    //MARK: - Actions
}
