import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SignInViewController: UIViewController, SignInViewLogic {
    //MARK: - Constants
    enum Constants {
        enum View {
            static let backgroundColor: UIColor = .red
        }
        enum SignInButton {
            static let title: String = "Войти"
            static let tintColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 30, weight: .semibold)
            static let backgroundColor: UIColor = .white
            static let cornerRadius: CGFloat = 20
            static let height: CGFloat = 80
            static let width: CGFloat = 230
            static let bottomConstraint: CGFloat = 30
        }
        enum NavigationBar {
            static let title: String = "Вход"
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 20, weight: .bold)
        }
        enum emailView {
            static let labelText: String = "Почта:"
            static let placeholder: String = "Введите почту..."
        }
        enum passwordView {
            static let labelText: String = "Пароль:"
            static let placeholder: String = "Введите пароль..."
        }
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    //MARK: - Variables
    private let interactor: SignInBuisnessLogic
    private let emailView: SignInInputUserDataView = SignInInputUserDataView(labelText: Constants.emailView.labelText, textFieldPlaceholder: Constants.emailView.placeholder)
    private let passwordView: SignInInputUserDataView = SignInInputUserDataView(labelText: Constants.passwordView.labelText, textFieldPlaceholder: Constants.passwordView.placeholder)
    private let signInButton: UIButton = UIButton(type: .system)
    
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
        view.backgroundColor = Constants.View.backgroundColor
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
        signInButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        signInButton.setTitle(Constants.SignInButton.title, for: .normal)
        signInButton.tintColor = Constants.SignInButton.tintColor
        signInButton.titleLabel?.font = Constants.SignInButton.font
        signInButton.backgroundColor = Constants.SignInButton.backgroundColor
        signInButton.layer.cornerRadius = Constants.SignInButton.cornerRadius
        view.addSubview(signInButton)
        
        signInButton.pinCenterX(to: view)
        signInButton.pinBottom(to: view.bottomAnchor, Constants.SignInButton.bottomConstraint)
        signInButton.setHeight(Constants.SignInButton.height)
        signInButton.setWidth(Constants.SignInButton.width)
        signInButton.addTarget(self, action: #selector (signInButtonTapped), for: .touchUpInside)
    }
    
    private func configureEmailView() {
        view.addSubview(emailView)
        emailView.pinCenterX(to: view)
        emailView.pinCenterY(to: view)
    }
    
    private func configurePasswordView() {
        view.addSubview(passwordView)
        passwordView.pinTop(to: emailView.bottomAnchor, 20)
        passwordView.pinCenterX(to: view)

    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Вход", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }

        
    //MARK: - Actions
    @objc private func signInButtonTapped() {
        guard let email = emailView.textField.text, !email.isEmpty,
              let password = passwordView.textField.text, !password.isEmpty else {
            showAlert(message: "Введите почту и пароль!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(message: "Ошибка входа: \(error.localizedDescription)")
                return
            }

            guard let userId = authResult?.user.uid else { return }
            
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    // Данные пользователя загружены
                    let userData = document.data()
                    print("Данные пользователя: \(userData ?? [:])")
                    
                    self.showAlert(message: "Успешный вход!") {
                        self.interactor.routeToProfile(request: SignIn.routeToProfile.Request(navigationController: self.navigationController))
                    }
                } else {
                    self.showAlert(message: "Ошибка загрузки данных: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                }
            }
        }
    }
}
