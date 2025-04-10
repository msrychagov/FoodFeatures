import UIKit
import Foundation

final class ProfileViewController: UIViewController, ProfileViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum SignOutButton {
            static let tintColor: UIColor = .white
            static let font: UIFont = .systemFont(ofSize: 30, weight: .bold)
            static let cornernRadius: CGFloat = 20
            static let bottomConstraint: CGFloat = 16
            static let width: CGFloat = 200
            static let height: CGFloat = 64
            static let text: String = "Выйти"
        }
        enum EditButton {
            static let tintColor: UIColor = .white
            static let font: UIFont = .systemFont(ofSize: 30, weight: .bold)
            static let cornernRadius: CGFloat = 20
            static let bottomConstraint: CGFloat = 16
            static let width: CGFloat = 200
            static let height: CGFloat = 64
            static let text: String = "Редактировать"
        }
        enum InfoView {
            static let backgroundColor: UIColor = .white
            static let topConstraint: CGFloat = 0
            static let horizontalConstraint: CGFloat = 24
            static let height: CGFloat = 80
            static let cornerRadius: CGFloat = 15
        }
        
        enum PreferencesTableView {
            static let backgroundColor: UIColor = .white
            static let cornerRadius: CGFloat = 15
            static let verticalConstraint: CGFloat = 16
            static let horizontalConstraint: CGFloat = 24
        }
        enum ShowAlert {
            static let errorTitle: String = "Ошибка"
            static let completeTitle: String = "Ок"
        }
        enum NavigationBar {
            static let title: String = ""
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 20, weight: .bold)
        }
    }
    
    //MARK: - Variables
    private let interactor: ProfileBuisnessLogic
    private let signOutButton: UIButton = UIButton(type: .system)
    private let editButton: UIButton = UIButton(type: .system)
    private let preferencesTableView: UITableView = UITableView()
    private let infoView: UserInfoView = UserInfoView()
    private var user: User?
    
    //MARK: Lyfecycles
    init (interactor: ProfileBuisnessLogic) {
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
        self.fetchUserInfo()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDataUpdated(_:)),
            name: Notification.Name("updateUserData"),
            object: nil)
    }
    
    @objc private func userDataUpdated(_ notification: Notification) {
        // Если объект уведомления содержит обновлённого пользователя, сразу обновляем UI
        let updatedUser = notification.object as? User
        self.user = updatedUser
        preferencesTableView.reloadData()
        configureUI()
    }

    private func configureUI() {
        configureNavigationBar()
        configureSignOutButton()
        configureEditButton()
        configureInfoView()
        configurePreferencesTableView()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Constants.NavigationBar.textColor
        navigationItem.title = Constants.NavigationBar.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.NavigationBar.textColor,
            .font: Constants.NavigationBar.font
        ]
    }
    
    private func configurePreferencesTableView() {
        preferencesTableView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        preferencesTableView.backgroundColor = Constants.PreferencesTableView.backgroundColor
        preferencesTableView.layer.cornerRadius = Constants.PreferencesTableView.cornerRadius
        preferencesTableView.register(TitleCell.self, forCellReuseIdentifier: TitleCell.reuseIdentifier)
        preferencesTableView.register(FeatureCell.self, forCellReuseIdentifier: FeatureCell.reuseIdentifier)
        preferencesTableView.dataSource = self
        view.addSubview(preferencesTableView)
        preferencesTableView.pinTop(to: infoView.bottomAnchor, Constants.PreferencesTableView.verticalConstraint)
        preferencesTableView.pinHorizontal(to: view, Constants.PreferencesTableView.horizontalConstraint)
        preferencesTableView.pinCenterX(to: view)
        preferencesTableView.pinBottom(to: editButton.topAnchor, Constants.PreferencesTableView.verticalConstraint)
    }
    
    private func configureInfoView() {
        infoView.configure(name: user!.name, email: user!.email)
        infoView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        infoView.backgroundColor = Constants.InfoView.backgroundColor
        infoView.layer.cornerRadius = Constants.InfoView.cornerRadius
        view.addSubview(infoView)
        infoView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.InfoView.topConstraint)
        infoView.pinCenterX(to: view.centerXAnchor)
        infoView.setHeight(Constants.InfoView.height)
        infoView.pinHorizontal(to: view, Constants.InfoView.horizontalConstraint)
    }
    

    private func configureSignOutButton() {
        signOutButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        signOutButton.backgroundColor = .white
        signOutButton.tintColor = Constants.SignOutButton.tintColor
        signOutButton.setTitle(Constants.SignOutButton.text, for: .normal)
        signOutButton.setTitleColor(.red, for: .normal)
        signOutButton.titleLabel?.font = Constants.SignOutButton.font
        signOutButton.layer.cornerRadius = Constants.SignOutButton.cornernRadius
        view.addSubview(signOutButton)
        signOutButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.SignOutButton.bottomConstraint)
        signOutButton.pinCenterX(to: view)
        signOutButton.pinHorizontal(to: view, 24)
        signOutButton.setHeight(Constants.SignOutButton.height)
        signOutButton.addTarget(self, action: #selector (signOutButtonTapped), for: .touchUpInside)
    }
    
    private func configureEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        editButton.backgroundColor = .white
        editButton.setTitle(Constants.EditButton.text, for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        editButton.titleLabel?.font = Constants.EditButton.font
        editButton.layer.cornerRadius = Constants.EditButton.cornernRadius
        view.addSubview(editButton)
        editButton.pinBottom(to: signOutButton.topAnchor, 16)
        editButton.pinCenterX(to: view)
        editButton.pinHorizontal(to: view, 24)
        editButton.setHeight(Constants.EditButton.height)
        editButton.addTarget(self, action: #selector (editButtonTapped), for: .touchUpInside)
        
    }
    
    private func fetchUserInfo() {
        AuthService().fetchCurrentUser(accessToken: AuthManager.shared.getToken()!){ [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        // Обновляем UI полученными данными
                        self?.user = user
                        self?.configureUI()
                    case .failure(let error):
                        // Показываем ошибку
                        self?.showAlert(message: error.localizedDescription)
                    }
                }
            }
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(title: Constants.ShowAlert.errorTitle, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.ShowAlert.completeTitle, style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

    
    //MARK: - Actions
    @objc private func signOutButtonTapped() {
        do {
            
            AuthManager.shared.clearToken()
            guard
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate,
                let navigationController = sceneDelegate.window?.rootViewController as? UINavigationController,
                let mainTabBar = navigationController.viewControllers.first as? MainTabBarController
            else {
                print("Неудача")
                return
            }
            
            mainTabBar.switchToUnauth()
            navigationController.present(AuthAssembly.build(), animated: true)
            // Создаем новый экран авторизации
//            let signInVC = AuthorizationAssembly.build()
//            let navController = UINavigationController(rootViewController: signInVC)
//            
//            // Делаем его корневым контроллером
//            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
//                sceneDelegate.window?.rootViewController = navController
//            } else {
//                UIApplication.shared.windows.first?.rootViewController = navController
//            }
            
        } catch let error {
            print("Ошибка выхода: \(error.localizedDescription)")
        }
    }
    
    @objc private func editButtonTapped() {
        let editVC = EditorAssembly.build(user: self.user!)
        editVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editVC, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (user?.preferences!.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = preferencesTableView.dequeueReusableCell(withIdentifier: TitleCell.reuseIdentifier, for: indexPath)
            
            guard let titleCell = cell as? TitleCell else { return cell }
            return titleCell
            
        default:
            let cell = preferencesTableView.dequeueReusableCell(withIdentifier: FeatureCell.reuseIdentifier, for: indexPath)
            guard let featureCell = cell as? FeatureCell else { return cell }
            featureCell.configure(feature: user?.preferences![indexPath.row - 1])
            return featureCell
        }
    }
    
    
}


