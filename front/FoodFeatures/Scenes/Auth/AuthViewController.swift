import UIKit

class AuthViewController: UIViewController, AuthViewLogic {
    private let interactor: AuthBuisnessLogic
    init(interactor: AuthBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["Вход", "Регистрация"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    // Это наша «шторка» (контейнер) – отдельное UIView.
    // Внутри него будем переключать контент (вход/регистрация)
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // закругляем только верхние углы
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Будем хранить ссылки на контроллеры, чтобы переключаться между ними
    private lazy var loginVC = SignInAssembly.build()
    private lazy var signUpVC = SignUpAssembly.build()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        
        setupSegmentedControl()
        setupBottomSheet()
        setupInitialChild() // по умолчанию показываем экран входа
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        
        // При изменении выбранного сегмента меняем экран внутри «шторки»
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupBottomSheet() {
        view.addSubview(bottomSheetView)
        
        // Зададим начальные констрейнты:
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16)
        ])
    }
    
    private func setupInitialChild() {
        // По умолчанию — loginVC
        addChild(loginVC)
        bottomSheetView.addSubview(loginVC.view)
        loginVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginVC.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            loginVC.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
            loginVC.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            loginVC.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor)
        ])
        loginVC.didMove(toParent: self)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showChildController(loginVC)
        default:
            showChildController(signUpVC)
        }
    }
    
    private func showChildController(_ vc: UIViewController) {
        // Удаляем предыдущий child VC, если он есть
        if children.contains(vc) {
            return // если уже показан, то ничего не делаем
        }
        
        // Снимаем старый
        for child in children {
            removeChildController(child)
        }
        
        // Добавляем новый
        addChild(vc)
        bottomSheetView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor)
        ])
        
        vc.didMove(toParent: self)
    }
    
    private func removeChildController(_ vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
