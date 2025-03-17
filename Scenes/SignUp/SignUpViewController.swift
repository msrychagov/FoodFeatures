import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SignUpViewController: UIViewController, SignUpViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum NameView {
            static let textFieldPlaceholder: String = "Имя"
            static let bottomConstant: CGFloat = 15
        }
        enum AgeView {
            static let textFieldPlaceholder: String = "Возраст"
            static let bottomConstant: CGFloat = 15
        }
        enum EmailView {
            static let textFieldPlaceholder: String = "Почта"
            static let bottomConstant: CGFloat = 15
        }
        enum PasswordView {
            static let textFieldPlaceholder: String = "Пароль"
            static let bottomConstant: CGFloat = 100
        }
        enum SexView {
            static let textFieldPlaceholder: String = "Пол"
            static let bottomConstant: CGFloat = 15
        }
        enum PreferencesView {
            static let textFieldPlaceholder: String = "Предпочтения"
            static let bottomConstant: CGFloat = 15
        }
        enum View {
            static let backgroundColor: UIColor = .red
        }
        enum NavigationBar {
            static let title: String = "Регистрация"
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 20, weight: .bold)
        }
        enum SignUpButton {
            static let title: String = "Зарегистрироваться"
            static let tintColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 25, weight: .semibold)
            static let backgroundColor: UIColor = .white
            static let cornerRadius: CGFloat = 20
            static let height: CGFloat = 80
            static let width: CGFloat = 300
            static let bottomConstraint: CGFloat = 30
        }
        
    }
    
    //MARK: - Variables
    private let interactor: SignUpBuisnessLogic
    private let signUpButton: UIButton = UIButton(type: .system)
    private let nameView: SignUpInputUserDataView = SignUpInputUserDataView(textFieldPlaceholder: Constants.NameView.textFieldPlaceholder)
    private let ageView: SignUpInputUserDataView = SignUpInputUserDataView(textFieldPlaceholder: Constants.AgeView.textFieldPlaceholder)
    private let emailView: SignUpInputUserDataView = SignUpInputUserDataView(textFieldPlaceholder: Constants.EmailView.textFieldPlaceholder)
    private let passwordView: SignUpInputUserDataView = SignUpInputUserDataView(textFieldPlaceholder: Constants.PasswordView.textFieldPlaceholder)
    private let preferencesView: SignUpInputUserDataView = SignUpInputUserDataView(textFieldPlaceholder: Constants.PreferencesView.textFieldPlaceholder)
    private let sexView: SignUpInputUserDataView = SignUpInputUserDataView(textFieldPlaceholder: Constants.SexView.textFieldPlaceholder)
    
    
    
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
        configureView()
        configureNavigationBar()
        configureSignUpButton()
        configurePasswordView()
        configureEmailView()
        configurePreferencesView()
        configureSexView()
        configureAgeView()
        configureNameView()
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
    
    private func configureNameView() {
        nameView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        view.addSubview(nameView)
        
        nameView.pinBottom(to: ageView.topAnchor, Constants.NameView.bottomConstant)
        nameView.pinCenterX(to: view)
    }
    
    private func configureAgeView() {
        ageView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        view.addSubview(ageView)
        
        ageView.pinBottom(to: sexView.topAnchor, Constants.AgeView.bottomConstant)
        ageView.pinCenterX(to: view)
    }
    private func configureSexView() {
        sexView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        view.addSubview(sexView)
        
        sexView.pinBottom(to: preferencesView.topAnchor, Constants.SexView.bottomConstant)
        sexView.pinCenterX(to: view)
    }
    private func configurePreferencesView() {
        preferencesView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        view.addSubview(preferencesView)
        
        preferencesView.pinBottom(to: emailView.topAnchor, Constants.PreferencesView.bottomConstant)
        preferencesView.pinCenterX(to: view)
    }
    private func configureEmailView() {
        emailView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        view.addSubview(emailView)
        
        emailView.pinBottom(to: passwordView.topAnchor, Constants.EmailView.bottomConstant)
        emailView.pinCenterX(to: view)
    }
    private func configurePasswordView() {
        passwordView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        view.addSubview(passwordView)
        
        passwordView.pinBottom(to: signUpButton.topAnchor, Constants.PasswordView.bottomConstant)
        passwordView.pinCenterX(to: view)
    }
    
    private func configureSignUpButton() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        signUpButton.setTitle(Constants.SignUpButton.title, for: .normal)
        signUpButton.tintColor = Constants.SignUpButton.tintColor
        signUpButton.titleLabel?.font = Constants.SignUpButton.font
        signUpButton.backgroundColor = Constants.SignUpButton.backgroundColor
        signUpButton.layer.cornerRadius = Constants.SignUpButton.cornerRadius
        view.addSubview(signUpButton)
        
        signUpButton.pinCenterX(to: view)
        signUpButton.pinBottom(to: view.bottomAnchor, Constants.SignUpButton.bottomConstraint)
        signUpButton.setHeight(Constants.SignUpButton.height)
        signUpButton.setWidth(Constants.SignUpButton.width)
        signUpButton.addTarget(self, action: #selector (signUpButtonTapped), for: .touchUpInside)
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Регистрация", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    //MARK: - Actions

    @objc private func signUpButtonTapped() {
        interactor.registerUser(request: SignUp.registerUser.Request(
            nameView: nameView,
            ageView: ageView,
            sexView: sexView,
            preferencesView: preferencesView,
            emailView: emailView,
            passwordView: passwordView,
            navigationController: self.navigationController
        ))
    }
}
