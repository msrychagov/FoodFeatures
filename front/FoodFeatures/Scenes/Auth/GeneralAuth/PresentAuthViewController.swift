import UIKit

class GeneralAuthViewController: UIViewController, GeneralAuthViewLogic {
    //MARK: - Constants
    enum Constants {
        enum SegmentControl {
            static let items: [String] = ["Вход", "Регистрация"]
            static let selectedSegmentIndex: Int = 0
            static let topConstraint: CGFloat = 16
        }
        
        enum BottomSheetView {
            static let cornerRadius: CGFloat = 16
            static let topConstraint: CGFloat = 16
        }
        
        enum SegmentsIndexes {
            static let signIn: Int = 0
            static let signUp: Int = 1
        }
    }
    
    //MARK: - Variables
    private let interactor: GeneralAuthBuisnessLogic
    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: Constants.SegmentControl.items)
        sc.selectedSegmentIndex = Constants.SegmentControl.selectedSegmentIndex
        sc.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        return sc
    }()
    
    // Это наша «шторка» (контейнер) – отдельное UIView.
    // Внутри него будем переключать контент (вход/регистрация)
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        view.layer.cornerRadius = Constants.BottomSheetView.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // закругляем только верхние углы
        view.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        return view
    }()
    
    // Будем хранить ссылки на контроллеры, чтобы переключаться между ними
    private lazy var loginVC = SignInAssembly.build()
    private lazy var signUpVC = SignUpAssembly.build()
    
    //MARK: - Lyfecycle
    init(interactor: GeneralAuthBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        
        setupSegmentedControl()
        setupBottomSheet()
        setupInitialChild() // по умолчанию показываем экран входа
    }
    
    //MARK: - SetUp
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        
        // При изменении выбранного сегмента меняем экран внутри «шторки»
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.SegmentControl.topConstraint),
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
            bottomSheetView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.BottomSheetView.topConstraint)
        ])
    }
    
    private func setupInitialChild() {
        // По умолчанию — loginVC
        addChild(loginVC)
        bottomSheetView.addSubview(loginVC.view)
        loginVC.view.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        NSLayoutConstraint.activate([
            loginVC.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            loginVC.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
            loginVC.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            loginVC.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor)
        ])
        loginVC.didMove(toParent: self)
    }
    
    //MARK: - Methods
    func showChildController(viewModel: GeneralAuthModels.ShowChildController.ViewModel) {
        let vc = viewModel.vc
        let request = GeneralAuthModels.ShowChildController.Request(vc: vc)
        interactor.showChildController(request: request)
        bottomSheetView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor)
        ])
        
        
        
        vc.didMove(toParent: self)
    }
    
    func removeChildController(viewModel: GeneralAuthModels.RemoveChildController.ViewModel) {
        let vc = viewModel.vc
        let request = GeneralAuthModels.RemoveChildController.Request(vc: vc)
        interactor.removeChildController(request: request)
    }
    
    //MARK: - Actions
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case Constants.SegmentsIndexes.signIn:
            interactor.showChildController(request: GeneralAuthModels.ShowChildController.Request(vc: loginVC))
        case Constants.SegmentsIndexes.signUp:
            interactor.showChildController(request: GeneralAuthModels.ShowChildController.Request(vc: signUpVC))
        default: break
        }
    }
}
