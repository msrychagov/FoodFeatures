import UIKit

final class SignInViewController: UIViewController, SignInViewLogic {
    
    //MARK: - Constants
    enum Constants {
        enum SignInButton {
            static let title: String = "Войти"
            static let tintColor: UIColor = .white
            static let font: UIFont = .systemFont(ofSize: 30, weight: .semibold)
            static let cornerRadius: CGFloat = 20
            static let height: CGFloat = 80
            static let width: CGFloat = 230
            static let bottomConstraint: CGFloat = 60
        }
        enum NavigationBar {
            static let title: String = "Вход"
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 20, weight: .bold)
        }
        enum emailView {
            static let labelText: String = "Почта:"
            static let placeholder: String = "Введите почту..."
            static let topConstraint: CGFloat = 32
        }
        enum passwordView {
            static let labelText: String = "Пароль:"
            static let placeholder: String = "Введите пароль..."
            static let topConstraint: CGFloat = 32
        }
        
        enum Alert {
            static let titleText: String = "Вход"
            static let actionText: String = "Ок"
            static let errorText401: String = "Неверные почта или пароль"
            static let errorCode: String = "401"
            static let emptyFieldsErrorText: String = "Введите почту и пароль"
        }
        
    }
    
    //MARK: - Variables
    private let interactor: SignInBuisnessLogic
    private let emailView: SignInInputUserDataView = SignInInputUserDataView(labelText: Constants.emailView.labelText, textFieldPlaceholder: Constants.emailView.placeholder)
    private let passwordView: SignInInputUserDataView = SignInInputUserDataView(labelText: Constants.passwordView.labelText, textFieldPlaceholder: Constants.passwordView.placeholder)
    private let signInButton: UIButton = UIButton(type: .system)
    private var email: String?
    private var password: String?
    
    var onLoginSuccess: (() -> Void)?
    
    //MARK: Lyfecycles
    init (interactor: SignInBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        configureUI()
    }
    
    private func configureUI() {
        configureView()
        configureNavigationBar()
        configureEmailView()
        configurePasswordView()
        configureSignInButton()
    }
    
    private func configureView() {
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Constants.NavigationBar.textColor
        navigationItem.title = Constants.NavigationBar.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.NavigationBar.textColor,
            .font: Constants.NavigationBar.font
        ]
    }
    
    private func configureSignInButton() {
        signInButton.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        signInButton.setTitle(Constants.SignInButton.title, for: .normal)
        signInButton.tintColor = Constants.SignInButton.tintColor
        signInButton.titleLabel?.font = Constants.SignInButton.font
        signInButton.backgroundColor = GeneralConstants.buttonsBackgroundColor
        signInButton.layer.cornerRadius = Constants.SignInButton.cornerRadius
        view.addSubview(signInButton)
        
        signInButton.pinCenterX(to: view)
        signInButton.pinBottom(to: view.bottomAnchor, Constants.SignInButton.bottomConstraint)
        signInButton.setHeight(Constants.SignInButton.height)
        signInButton.setWidth(Constants.SignInButton.width)
        signInButton.addTarget(self, action: #selector (signInButtonTapped), for: .touchUpInside)
    }
    
    private func configureEmailView() {
        emailView.onTextEdit = { [weak self] text in
            self?.email = text}
        view.addSubview(emailView)
        emailView.pinCenterX(to: view)
        emailView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.emailView.topConstraint)
    }
    
    private func configurePasswordView() {
        passwordView.onTextEdit = { [weak self] text in
            self?.password = text}
        view.addSubview(passwordView)
        passwordView.pinTop(to: emailView.bottomAnchor, Constants.passwordView.topConstraint)
        passwordView.pinCenterX(to: view)
        
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: Constants.Alert.titleText, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Alert.actionText, style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    // Ошибка авторизации
    func displaySignInFailure(viewModel: SignInModles.SignIn.ViewModelFailure) {
        // Показываем алерт с текстом ошибки
        if viewModel.errorMessage.contains(Constants.Alert.errorCode) {
            showAlert(message: viewModel.errorMessage)
        }
    }
    
    
    //MARK: - Actions
    @objc private func signInButtonTapped() {
        // 2. Формируем Request и отправляем в Interactor
        let request = SignInModles.SignIn.Request(
            username: self.email ?? "",
            password: self.password ?? ""
        )
        interactor.signIn(request: request)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
