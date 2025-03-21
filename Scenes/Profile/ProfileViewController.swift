import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController, ProfileViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    //MARK: - Variables
    private let interactor: ProfileBuisnessLogic
    private let signOutButton: UIButton = UIButton(type: .system)
    
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
        view.backgroundColor = .red
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configureSignOutButton()
    }
    
    private func configureSignOutButton() {
        signOutButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        view.addSubview(signOutButton)
        signOutButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 10)
        signOutButton.pinCenterX(to: view)
        signOutButton.setWidth(200)
        signOutButton.setHeight(50)
        signOutButton.backgroundColor = .white
        signOutButton.addTarget(self, action: #selector (signOutButtonTapped), for: .touchUpInside)
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
