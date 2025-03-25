import UIKit

final class AuthorizationViewController: UIViewController, AuthorizationViewLogic {
    //MARK: - Constants
    enum Constants {
        enum SignInButton {
            static let title: String = "Вход"
            static let tintColor: UIColor = .white
            static let font: UIFont = .systemFont(ofSize: 30, weight: .semibold)
            static let cornerRadius: CGFloat = 20
            static let height: CGFloat = 80
            static let width: CGFloat = 230
            static let topConstraint: CGFloat = 20
        }
        enum SignUpButton {
            static let title: String = "Регистрация"
            static let tintColor: UIColor = .white
            static let font: UIFont = .systemFont(ofSize: 30, weight: .semibold)
            static let cornerRadius: CGFloat = 20
            static let height: CGFloat = 80
            static let width: CGFloat = 230
            static let topConstraint: CGFloat = 25
        }
        enum AuthorizationLabel {
            static let topConstraint: CGFloat = 140
            static let textAlignment: NSTextAlignment = .center
            static let font = UIFont.systemFont(ofSize: 35, weight: .heavy)
            static let textColor: UIColor = .black
            static let backgroundColor: UIColor = .clear
            static let text: String = "Авторизация"
        }
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    //MARK: - Variables
    private let interactor: AuthorizationBuisnessLogic
    private let authorizationLabel: UILabel = UILabel()
    private let signInButton: UIButton = UIButton(type: .system)
    private let signUpButton: UIButton = UIButton(type: .system)
    
    //MARK: Lyfecycles
    init (interactor: AuthorizationBuisnessLogic) {
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
        configureUI()
    }
    
    private func configureUI() {
        configureAuthorizationLabel()
        configureSignInButton()
        configureSignUpButton()
    }
    
    private func configureAuthorizationLabel() {
        authorizationLabel.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        authorizationLabel.textAlignment = Constants.AuthorizationLabel.textAlignment
        authorizationLabel.font = Constants.AuthorizationLabel.font
        authorizationLabel.textColor = Constants.AuthorizationLabel.textColor
        authorizationLabel.backgroundColor = Constants.AuthorizationLabel.backgroundColor
        authorizationLabel.text = Constants.AuthorizationLabel.text
        view.addSubview(authorizationLabel)
        
        authorizationLabel.pinCenterX(to: view)
        authorizationLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.AuthorizationLabel.topConstraint)
    }
    
    private func configureSignInButton() {
        signInButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        signInButton.setTitle(Constants.SignInButton.title, for: .normal)
        signInButton.tintColor = Constants.SignInButton.tintColor
        signInButton.titleLabel?.font = Constants.SignInButton.font
        signInButton.backgroundColor = GeneralConstants.buttonsBackgroundColor
        signInButton.layer.cornerRadius = Constants.SignInButton.cornerRadius
        view.addSubview(signInButton)
        
        signInButton.pinCenterX(to: view)
        signInButton.pinCenterY(to: view)
        signInButton.setHeight(Constants.SignInButton.height)
        signInButton.setWidth(Constants.SignInButton.width)
        signInButton.addTarget(self, action: #selector (signInButtonTapped), for: .touchUpInside)
    }
    
    private func configureSignUpButton() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        signUpButton.setTitle(Constants.SignUpButton.title, for: .normal)
        signUpButton.tintColor = Constants.SignUpButton.tintColor
        signUpButton.titleLabel?.font = Constants.SignUpButton.font
        signUpButton.backgroundColor = GeneralConstants.buttonsBackgroundColor
        signUpButton.layer.cornerRadius = Constants.SignUpButton.cornerRadius
        view.addSubview(signUpButton)
        
        signUpButton.pinCenterX(to: view)
        signUpButton.pinTop(to: signInButton.bottomAnchor, Constants.SignUpButton.topConstraint)
        signUpButton.setHeight(Constants.SignUpButton.height)
        signUpButton.setWidth(Constants.SignUpButton.width)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
        
    //MARK: - Actions
    @objc func signInButtonTapped() {
        interactor.routeToSignIn(request: Authorization.routeToSignIn.Request(navigationController: navigationController))
    }
    @objc func signUpButtonTapped() {
        interactor.routeToSignUp(request: Authorization.routeToSignUp.Request(navigationController: navigationController))
    }
}
