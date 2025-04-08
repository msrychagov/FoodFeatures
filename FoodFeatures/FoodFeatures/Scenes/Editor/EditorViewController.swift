import UIKit

final class EditorViewController: UIViewController, EditorViewLogic {
    
    func displayPreferences(viewModel: EditorModels.FetchPreferences.ViewModel) {
        self.displayedPrefernces = viewModel.preferences
        preferencesTableView.reloadData()
    }
    
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
        enum SaveButton {
            static let title: String = "Сохранить изменения"
            static let font: UIFont = .systemFont(ofSize: 25, weight: .semibold)
            static let cornerRadius: CGFloat = 20
            static let height: CGFloat = 80
            static let width: CGFloat = 300
            static let bottomConstraint: CGFloat = 60
        }
        
    }
    
    //MARK: - Variables
    private let interactor: EditorBuisnessLogic
    private let nameView: UserDataView = UserDataView(textFieldPlaceholder: Constants.NameView.textFieldPlaceholder)
    private let emailView: UserDataView = UserDataView(textFieldPlaceholder: Constants.EmailView.textFieldPlaceholder)
    @objc private let saveButton: UIButton = UIButton(type: .system)
    private let preferencesLabel: UILabel = UILabel()
    private let stackView: UIStackView = UIStackView()
    private let preferencesTableView: UITableView = UITableView()
    private var displayedPrefernces: [Preference] = []
    
    //MARK: Lyfecycles
    init (interactor: EditorBuisnessLogic) {
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
        interactor.fetchUser()
        interactor.fetchPreferences()
        configureUI()
    }
    
    private func configureUI() {
        configureSaveButton()
        configurePreferencesLabel()
        configurePreferencesTableView()
        configureStackView()
    }
    
    private func configurePreferencesLabel() {
        preferencesLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        preferencesLabel.font = .systemFont(ofSize: 22, weight: .bold)
        preferencesLabel.textAlignment = .center
        preferencesLabel.text = "Выберите пищевые ограничения:"
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
        
        for subView in [nameView, emailView, preferencesLabel, preferencesTableView] {
            stackView.addArrangedSubview(subView)
        }
        view.addSubview(stackView)
        stackView.pinCenterX(to: view.centerXAnchor)
        stackView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 48)
        stackView.pinBottom(to: saveButton.topAnchor, 48)
        stackView.setWidth(300)
    }
    
    private func configureSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        saveButton.backgroundColor = GeneralConstants.buttonsBackgroundColor
        saveButton.setTitle(Constants.SaveButton.title, for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = Constants.SaveButton.font
        saveButton.layer.cornerRadius = Constants.SaveButton.cornerRadius
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.pinCenterX(to: view)
        saveButton.pinBottom(to: view, Constants.SaveButton.bottomConstraint)
        saveButton.setHeight(Constants.SaveButton.height)
        saveButton.setWidth(Constants.SaveButton.width)
    }
    
    func setUserValues(viewModel: EditorModels.FetchUser.ViewModel) {
        nameView.textField.text = viewModel.name
        emailView.textField.text = viewModel.email
    }
    
        
    //MARK: - Actions
    @objc func saveButtonTapped() {
        let request = EditorModels.SaveChanges.Request(name: nameView.textField.text ?? "", email: emailView.textField.text ?? "")
        interactor.saveChanges(request: request)
        navigationController?.popViewController(animated: true)
    }
}

extension EditorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedPrefernces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PreferenceCell.reuseIdentifier, for: indexPath)
        guard let preferenceCell = cell as? PreferenceCell else { return cell }
        preferenceCell.configure(with: displayedPrefernces[indexPath.row])
        preferenceCell.didSelectedPreference = { [weak self] in
            guard let self = self else { return }
            interactor.updatePreferences(request: EditorModels.UpdatePreferences.Request(chosenPreferenceIndex: indexPath.row))
        }
        return preferenceCell
    }
    
    
}
