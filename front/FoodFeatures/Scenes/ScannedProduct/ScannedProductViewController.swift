import UIKit

final class ScannedProductViewController: UIViewController, ScannedProductViewLogic {
    
    
    func displayScanFailure(viewModel: ScannedProductModels.LoadProduct.Failure.ViewModel) {
        showAlert(message: viewModel.errorMessage)
    }
    
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum NavigationBar {
            static let title: String = "Отсканированный продукт"
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    //MARK: - Variables
    private let interactor: ScannedProductBuisnessLogic
    private let titleLabel: UILabel = UILabel()
    private let brandLabel: UILabel = UILabel()
    private let allergensLabel: UILabel = UILabel()
    private let tracesLabel: UILabel = UILabel()
    private let nameStack: UIStackView = UIStackView()
    private let allergensStack: UIStackView = UIStackView()
    private let tracesStack: UIStackView = UIStackView()
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    private var allergens: [Allergen] = []
    private var traces: [String] = []
    
    //MARK: Lyfecycles
    init (interactor: ScannedProductBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
            // Убираем полупрозрачность и ставим нужные цвета
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.tintColor = .black
            
        interactor.loadProduct()
    }

    
    //MARK: - Configures
    func configure(viewModel: ScannedProductModels.LoadProduct.Success.ViewModel) {
        titleLabel.text = viewModel.productName
        brandLabel.text = viewModel.brand
        allergens = viewModel.allergens
        traces = viewModel.traces
        showAlert(message: viewModel.message)
        configureUI()
        print(allergens)
    }
    private func configureUI() {
        configureTracesLabel()
        configureAllergensLabel()
        configureScrollView()
        configureContentView()
        configureNavigationBar()
        configureBrandLabel()
        configureTitleLabel()
        configureNameStack()
        configureAllergenStack()
        configureTracesStack()
    }
    
    func configureNavidationBar() {
        navigationItem.titleView?.tintColor = .black
    }
    
    func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        view.addSubview(scrollView)
//        scrollView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
//        scrollView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
//        scrollView.pinHorizontal(to: view)
        
        NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        scrollView.addSubview(contentView)
//        contentView.pinVertical(to: scrollView)
//        contentView.pinHorizontal(to: scrollView)
        NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

                // Важно зафиксировать ширину contentView по ширине scrollView,
                // чтобы контент не скроллился горизонтально
                contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
            ])
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Constants.NavigationBar.textColor
        navigationItem.title = Constants.NavigationBar.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.NavigationBar.textColor,
            .font: Constants.NavigationBar.font
        ]
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        titleLabel.numberOfLines = 2
        titleLabel.backgroundColor = .white
        titleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .left
    }
    
    private func configureBrandLabel() {
        brandLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        brandLabel.numberOfLines = 2
        brandLabel.backgroundColor = .white
        brandLabel.font = .systemFont(ofSize: 24, weight: .bold)
        brandLabel.textAlignment = .left
    }
    
    private func configureAllergenStack() {
        allergensStack.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        allergensStack.backgroundColor = .white
        allergensStack.layer.cornerRadius = 16
        allergensStack.axis = .vertical
        allergensStack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        allergensStack.isLayoutMarginsRelativeArrangement = true
        allergensStack.addArrangedSubview(allergensLabel)
        
        if allergens.count == 0 {
            let allergenView = AllergenView(frame: .zero, allergen: Allergen(text: "Без аллергенов", imageString: "checkmark.square.fill"))
            allergensStack.addArrangedSubview(allergenView)
        } else {
            for allergen in allergens {
                print(allergen)
                let allergenView = AllergenView(frame: .zero, allergen: allergen)
                allergensStack.addArrangedSubview(allergenView)
            }
        }
        
        contentView.addSubview(allergensStack)
        allergensStack.pinCenterX(to: contentView)
        allergensStack.pinTop(to: nameStack.bottomAnchor, 16)
        allergensStack.pinHorizontal(to: contentView, 8)
    }
    
    private func configureTracesStack() {
        tracesStack.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        tracesStack.axis = .vertical
        tracesStack.backgroundColor = .white
        tracesStack.layer.cornerRadius = 16
        tracesStack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        tracesStack.isLayoutMarginsRelativeArrangement = true
        tracesStack.addArrangedSubview(tracesLabel)
        
        if traces.count == 0 {
            let traceView = TraceView(frame: .zero, trace: "Нет следов аллергенов")
            tracesStack.addArrangedSubview(traceView)
        } else {
            for trace in traces {
                let traceView = TraceView(frame: .zero, trace: trace)
                tracesStack.addArrangedSubview(traceView)
            }
        }
        contentView.addSubview(tracesStack)
        tracesStack.pinCenterX(to: contentView)
        tracesStack.pinTop(to: allergensStack.bottomAnchor, 16)
        tracesStack.pinHorizontal(to: contentView, 8)
        tracesStack.pinBottom(to: contentView)
    }
    
    private func configureNameStack() {
        nameStack.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        nameStack.axis = .vertical
        nameStack.backgroundColor = .white
        nameStack.layer.cornerRadius = 16
        nameStack.addArrangedSubview(tracesLabel)
        nameStack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        nameStack.isLayoutMarginsRelativeArrangement = true

        for nameLabel in [brandLabel, titleLabel] {
            nameStack.addArrangedSubview(nameLabel)
        }
        contentView.addSubview(nameStack)
        nameStack.pinCenterX(to: contentView)
        nameStack.pinTop(to: contentView.topAnchor, 16)
        nameStack.pinHorizontal(to: contentView, 8)
    }
    
    private func configureAllergensLabel() {
        allergensLabel.textColor = .black
        allergensLabel.text = "Аллергены:"
        allergensLabel.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private func configureTracesLabel() {
        tracesLabel.textColor = .black
        tracesLabel.text = "Продукт может содержать следы:"
        tracesLabel.font = .systemFont(ofSize: 24, weight: .bold)
        tracesLabel.numberOfLines = 2
    }
    
        
    //MARK: - Methods
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Проверка продукта", message: message, preferredStyle: .alert)
        if message == "Продукт не найден" {
            let okAction = UIAlertAction(title: "ОК", style: .default) {[weak self] _ in
                self?.interactor.goBackToScanner(request: ScannedProductModels.GoBackToScanner.Request(navigationController: self?.navigationController))
            }
            alert.addAction(okAction)
        } else {
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Actions
}
