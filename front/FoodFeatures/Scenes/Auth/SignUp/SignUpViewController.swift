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
        enum PreferencesLabel {
            static let font: UIFont = .systemFont(ofSize: 22, weight: .bold)
            static let textAligment: NSTextAlignment = .center
            static let text: String = "Пищевые ограничения:"
        }
        enum PreferencesTableView {
            static let backgroundColor: UIColor = .clear
            static let separatorStyle: UITableViewCell.SeparatorStyle = .none
        }
        
        enum StackView {
            static let backgroundColor: UIColor = .clear
            static let axis: NSLayoutConstraint.Axis = .vertical
            static let spacing: CGFloat = 8
            static let clipsToBounds: Bool = true
            static let topConstraint: CGFloat = 32
            static let bottomConstraint: CGFloat = 32
            static let width: CGFloat = 300
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
        
        enum SignUpFailureMessages {
            static let authError: String = "Ошибка авторизации"
            static let emptyData: String = "Все данные должны быть заполнены"
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
    private var displayedPrefernces: [Preference] = []
    private var name: String?
    private var email: String?
    private var password: String?
    
    
    
    //MARK: Lyfecycles
    init (interactor: SignUpBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchPreferences()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        configureUI()
    }
    
    //MARK: - Methods
    func displayPreferences(viewModel: SignUpModels.UpdatePrefernces.ViewModel) {
        self.displayedPrefernces = viewModel.preferences
        preferencesTableView.reloadData()
    }
    
    func displaySignUpSuccess(viewModel: SignUpModels.SignUp.ViewModelSuccess) {
        interactor.setUpTabBar()
    }
    
    func displaySignUpFailure(viewModel: SignUpModels.SignUp.ViewModelFailure) {
        interactor.showAlert(request: .init(message: Constants.SignUpFailureMessages.authError))
    }
    
    //MARK: - Configure
    private func configureUI() {
        configureView()
        configureNavigationBar()
        configureSignUpButton()
        configurePreferencesLabel()
        configurePreferencesTableView()
        configureDataViews()
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
        preferencesLabel.font = Constants.PreferencesLabel.font
        preferencesLabel.textAlignment = Constants.PreferencesLabel.textAligment
        preferencesLabel.text = Constants.PreferencesLabel.text
    }
    private func configurePreferencesTableView() {
        preferencesTableView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        preferencesTableView.backgroundColor = Constants.PreferencesTableView.backgroundColor
        preferencesTableView.separatorStyle = Constants.PreferencesTableView.separatorStyle
        preferencesTableView.register(PreferenceCell.self, forCellReuseIdentifier: PreferenceCell.reuseIdentifier)
        preferencesTableView.dataSource = self
    }
    
    private func configureDataViews() {
        nameView.delegate = self
        emailView.delegate = self
        passwordView.delegate = self
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        stackView.backgroundColor = Constants.StackView.backgroundColor
        stackView.axis = Constants.StackView.axis
        stackView.spacing = Constants.StackView.spacing
        stackView.clipsToBounds = Constants.StackView.clipsToBounds
        
        for subView in [nameView, emailView, passwordView, preferencesLabel, preferencesTableView] {
            stackView.addArrangedSubview(subView)
        }
        view.addSubview(stackView)
        stackView.pinCenterX(to: view.centerXAnchor)
        stackView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.StackView.topConstraint)
        stackView.pinBottom(to: signUpButton.topAnchor, Constants.StackView.bottomConstraint)
        stackView.setWidth(Constants.StackView.width)
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
    
    //MARK: - Actions
    @objc private func signUpButtonTapped() {
        interactor.checkFields(
            request: SignUpModels.CheckFields.Request(
                name: self.name ?? "",
                email: self.email ?? "",
                password: self.password ?? "")) { [weak self] success in
                    if success {
                        let request = SignUpModels.SignUp.Request(name: self!.nameView.textField.text!, email: self!.emailView.textField.text!, password: self!.passwordView.textField.text!)
                        self?.interactor.signUp(request: request)
                    } else {
                        self?.interactor.showAlert(request: .init(message: Constants.SignUpFailureMessages.emptyData))
                    }
                }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - DataSource
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

extension SignUpViewController: UserDataViewDelegate {
    func userDataView(type: String, text: String) {
        switch type {
        case "Имя": self.name = text
        case "Почта": self.email = text
        case "Пароль": self.password = text
        default:
            return
        }
    }
}
