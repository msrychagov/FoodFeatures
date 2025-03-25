import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController, ProfileViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum SignOutButton {
            static let tintColor: UIColor = .white
            static let font: UIFont = .systemFont(ofSize: 24, weight: .bold)
            static let cornernRadius: CGFloat = 20
            static let bottomConstraint: CGFloat = 10
            static let width: CGFloat = 200
            static let height: CGFloat = 50
            static let text: String = "Выйти"
        }
        enum InfoView {
            static var name: String = "Рычагов Михаил"
            static let topConstraint: CGFloat = 10
            static let width: CGFloat = 300
            static let height: CGFloat = 70
            static let cornerRadius: CGFloat = 15
        }
        enum ShowAlert {
            static let errorTitle: String = "Ошибка"
            static let completeTitle: String = "Ок"
        }
    }
    
    //MARK: - Variables
    private let interactor: ProfileBuisnessLogic
    private let signOutButton: UIButton = UIButton(type: .system)
    private let nameLabel: UILabel = UILabel()
    private let emailLabel: UILabel = UILabel()
    private let infoView: UserInfoView = UserInfoView()
    private let authService = AuthService()
    private var name: String = String()
    
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
        fetchUserInfo()
    }
    
    private func configureUI() {
        configureSignOutButton()
        configureInfoView()
    }
    
    private func configureInfoView() {
        infoView.configure(name: name)
        infoView.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        infoView.layer.cornerRadius = Constants.InfoView.cornerRadius
        view.addSubview(infoView)
        infoView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.InfoView.topConstraint)
        infoView.pinCenterX(to: view.centerXAnchor)
        infoView.setHeight(Constants.InfoView.height)
        infoView.setWidth(Constants.InfoView.width)
    }
    

    private func configureSignOutButton() {
        signOutButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        signOutButton.backgroundColor = GeneralConstants.buttonsBackgroundColor
        signOutButton.tintColor = Constants.SignOutButton.tintColor
        signOutButton.setTitle(Constants.SignOutButton.text, for: .normal)
        signOutButton.setTitleColor(.red, for: .normal)
        signOutButton.titleLabel?.font = Constants.SignOutButton.font
        signOutButton.layer.cornerRadius = Constants.SignOutButton.cornernRadius
        view.addSubview(signOutButton)
        signOutButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.SignOutButton.bottomConstraint)
        signOutButton.pinCenterX(to: view)
        signOutButton.setWidth(Constants.SignOutButton.width)
        signOutButton.setHeight(Constants.SignOutButton.height)
        signOutButton.backgroundColor = .white
        signOutButton.addTarget(self, action: #selector (signOutButtonTapped), for: .touchUpInside)
    }
    
    private func fetchUserInfo() {
        authService.fetchCurrentUser(accessToken: AuthManager.shared.getToken()!){ [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        // Обновляем UI полученными данными
                        self?.name = user.name
                        print(self?.name)
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
            
            try AuthManager.shared.clearToken()
            
            // Создаем новый экран авторизации
            let signInVC = AuthorizationAssembly.build()
            let navController = UINavigationController(rootViewController: signInVC)
            
            // Делаем его корневым контроллером
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = navController
            } else {
                UIApplication.shared.windows.first?.rootViewController = navController
            }
            
        } catch let error {
            print("Ошибка выхода: \(error.localizedDescription)")
        }
    }
}
