import UIKit

final class SignUpViewController: UIViewController, SignUpViewLogic {
    
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum NameView {
            static let textFieldPlaceholder: String = "Имя"
            static let bottomConstraint: CGFloat = 15
        }
        enum EmailView {
            static let textFieldPlaceholder: String = "Почта"
            static let bottomConstraint: CGFloat = 15
        }
        enum PasswordView {
            static let textFieldPlaceholder: String = "Пароль"
            static let bottomConstraint: CGFloat = 150
        }
        enum PreferencesView {
            static let textFieldPlaceholder: String = "Предпочтения"
            static let bottomConstant: CGFloat = 15
        }
        enum NavigationBar {
            static let title: String = "Регистрация"
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 20, weight: .bold)
        }
        enum SignUpButton {
            static let title: String = "Зарегистрироваться"
            static let tintColor: UIColor = .white
            static let font: UIFont = .systemFont(ofSize: 25, weight: .semibold)
            static let cornerRadius: CGFloat = 20
            static let height: CGFloat = 80
            static let width: CGFloat = 300
            static let bottomConstraint: CGFloat = 60
        }
        
    }
    
    //MARK: - Variables
    private let interactor: SignUpBuisnessLogic
    private let signUpButton: UIButton = UIButton(type: .system)
    private let nameView: UserDataView = UserDataView(textFieldPlaceholder: Constants.NameView.textFieldPlaceholder)
    private let emailView: UserDataView = UserDataView(textFieldPlaceholder: Constants.EmailView.textFieldPlaceholder)
    private let passwordView: UserDataView = UserDataView(textFieldPlaceholder: Constants.PasswordView.textFieldPlaceholder)
    private let preferencesLabel: UILabel = UILabel()
    private let stackView: UIStackView = UIStackView()
    private let preferencesTableView: UITableView = UITableView()
    private let authService = AuthService()
    private var displayedPrefernces: [Preference] = []
    
    
    
    
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
        interactor.fetchPreferences()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        configureUI()
    }
    
    private func configureUI() {
        configureView()
        configureNavigationBar()
        configureSignUpButton()
        configurePreferencesLabel()
        configurePreferencesTableView()
        configureStackView()
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
    private func configurePreferencesLabel() {
        preferencesLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        preferencesLabel.font = .systemFont(ofSize: 22, weight: .bold)
        preferencesLabel.textAlignment = .center
        preferencesLabel.text = "Пищевые ограничения:"
    }
    private func configurePreferencesTableView() {
        preferencesTableView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        preferencesTableView.backgroundColor = .clear
        preferencesTableView.separatorStyle = .none
        preferencesTableView.register(PreferenceCell.self, forCellReuseIdentifier: PreferenceCell.reuseIdentifier)
        preferencesTableView.dataSource = self
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.clipsToBounds = true
        
        for subView in [nameView, emailView, passwordView, preferencesLabel, preferencesTableView] {
            stackView.addArrangedSubview(subView)
        }
        view.addSubview(stackView)
        stackView.pinCenterX(to: view.centerXAnchor)
        stackView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 32)
        stackView.pinBottom(to: signUpButton.topAnchor, 32)
        stackView.setWidth(300)
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
    
    func displayPreferences(viewModel: SignUpModels.UpdatePrefernces.ViewModel) {
        self.displayedPrefernces = viewModel.preferences
        preferencesTableView.reloadData()
    }
    
    func displaySignUpSuccess(viewModel: SignUpModels.SignUp.ViewModelSuccess) {
        // Здесь можно, например, показать сообщение об успехе, а затем выполнить переход:
        print("Токен получен: \(viewModel.token)")
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let navigationController = sceneDelegate.window?.rootViewController as? UINavigationController,
            let mainTabBar = navigationController.viewControllers.first as? MainTabBarController
        else {
            print("Неудача")
            return
        }
        
        mainTabBar.switchToAuth()
        self.dismiss(animated: true)
    }
    
    // При ошибке регистрации
    func displaySignUpFailure(viewModel: SignUpModels.SignUp.ViewModelFailure) {
        showAlert(message: viewModel.errorMessage)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    //MARK: - Actions
    
    @objc private func signUpButtonTapped() {
        guard let name = nameView.textField.text,
              let email = emailView.textField.text,
              let password = passwordView.textField.text,
              !name.isEmpty, !email.isEmpty, !password.isEmpty
        else {
            showAlert(message: "Пожалуйста, заполните все поля")
            return
        }
        let request = SignUpModels.SignUp.Request(name: name, email: email, password: password)
        interactor.signUp(request: request)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension SignUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedPrefernces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PreferenceCell.reuseIdentifier, for: indexPath)
        guard let preferenceCell = cell as? PreferenceCell else { return cell }
        preferenceCell.configure(with: displayedPrefernces[indexPath.row])
        preferenceCell.didSelectedPreference = { [weak self] in
            guard let self = self else { return }
            interactor.updatePreferences(request: SignUpModels.UpdatePrefernces.Request(preferenceIndex: indexPath.row))
        }
        return preferenceCell
    }
    
    
}

