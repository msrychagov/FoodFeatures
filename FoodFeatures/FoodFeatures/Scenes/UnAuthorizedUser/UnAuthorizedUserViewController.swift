import UIKit

final class UnAuthorizedUserViewController: UIViewController, UnAuthorizedUserViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum AuthLabel {
            static let text: String = "Вы не авторизовались"
            static let font: UIFont = .systemFont(ofSize: 24, weight: .bold)
            static let bottomConstraint: CGFloat = 24
        }
        
        enum AuthButton {
            static let title: String = "Авторизоваться"
            static let titleFont: UIFont = .systemFont(ofSize: 20, weight: .medium)
            static let borderColor: CGColor = UIColor.black.cgColor
            static let width: CGFloat = 200
            static let height: CGFloat = 50
            static let borderWidth: CGFloat = 3
            static let cornerRadius: CGFloat = 8
            static let titleColor: UIColor = .black
        }
    }
    
    //MARK: - Variables
    private let interactor: UnAuthorizedUserBuisnessLogic
    private let authLabel: UILabel = UILabel()
    private let authButton: UIButton = UIButton()
    
    //MARK: Lyfecycles
    init (interactor: UnAuthorizedUserBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        configureUI()
    }
    
    private func configureUI() {
        configureAuthButton()
        configureAuthLabel()
    }
    
    private func configureAuthLabel() {
        authLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        authLabel.text = Constants.AuthLabel.text
        authLabel.font = Constants.AuthLabel.font
        view.addSubview(authLabel)
        authLabel.pinCenterX(to: view)
        authLabel.pinBottom(to: authButton.topAnchor, Constants.AuthLabel.bottomConstraint)
    }
    
    private func configureAuthButton() {
        authButton.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        authButton.setTitle(Constants.AuthButton.title, for: .normal)
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        authButton.layer.borderWidth = Constants.AuthButton.borderWidth
        authButton.layer.borderColor = Constants.AuthButton.borderColor
        authButton.layer.cornerRadius = Constants.AuthButton.cornerRadius
        authButton.setTitleColor(Constants.AuthButton.titleColor, for: .normal)
        authButton.titleLabel?.font = Constants.AuthButton.titleFont
        view.addSubview(authButton)
        authButton.pinCenterX(to: view)
        authButton.pinCenterY(to: view)
        authButton.setHeight(Constants.AuthButton.height)
        authButton.setWidth(Constants.AuthButton.width)
    }
    
    //MARK: - Actions
    @objc func authButtonTapped() {
        navigationController?.present(AuthAssembly.build(), animated: true)
    }
}
