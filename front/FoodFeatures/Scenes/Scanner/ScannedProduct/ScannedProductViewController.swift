import UIKit

final class ScannedProductViewController: UIViewController, ScannedProductViewLogic {
    
    
    func displayScanFailure(viewModel: ScannedProductModels.LoadProduct.Failure.ViewModel) {
        showAlert(message: viewModel.errorMessage)
    }
    
    //MARK: - Constants
    enum Constants {
        enum TitleLabel {
            static let numberofLines: Int = 2
            static let backgroundColor: UIColor = .white
            static let font: UIFont = .systemFont(ofSize: 24, weight: .medium)
            static let textColor: UIColor = .gray
            static let textAlignment: NSTextAlignment = .left
        }
        enum BrandLabel {
            static let numberLines: Int = 2
            static let backgroundcolor: UIColor = .white
            static let font: UIFont = .systemFont(ofSize: 24, weight: .bold)
            static let textAligment: NSTextAlignment = .left
        }
        enum AllergenStack {
            static let backgroundColor: UIColor = .white
            static let cornerRadius: CGFloat = 16
            static let axis: NSLayoutConstraint.Axis = .vertical
            static let layoutMargins: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
            static let isLayoutMarginsRelativeArrangement: Bool = true
            static let topConstraint: CGFloat = 16
            static let horizontalConstraint: CGFloat = 8
            static let emptyAllergen: Allergen = Allergen(text: "Без аллергенов", imageString: "checkmark.square.fill")
        }
        enum TracesStack {
            static let backgroundColor: UIColor = .white
            static let cornerRadius: CGFloat = 16
            static let axis: NSLayoutConstraint.Axis = .vertical
            static let layoutMargins: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
            static let isLayoutMarginsRelativeArrangement: Bool = true
            static let topConstraint: CGFloat = 16
            static let horizontalConstraint: CGFloat = 8
            static let emptyTrace: String = "Нет следов аллергенов"
        }
        enum NameStack {
            static let backgroundColor: UIColor = .white
            static let cornerRadius: CGFloat = 16
            static let axis: NSLayoutConstraint.Axis = .vertical
            static let layoutMargins: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
            static let isLayoutMarginsRelativeArrangement: Bool = true
            static let topConstraint: CGFloat = 16
            static let horizontalConstraint: CGFloat = 8
        }
        enum TracesLabel {
            static let textColor: UIColor = .black
            static let text: String = "Продукт может содержать следы:"
            static let font: UIFont = .systemFont(ofSize: 24, weight: .bold)
            static let numberOfLines: Int = 2
        }
        enum AllergenLabel {
            static let textColor: UIColor = .black
            static let text: String = "Аллергены:"
            static let font: UIFont = .systemFont(ofSize: 24, weight: .bold)
        }
        enum NavigationBar {
            static let title: String = "Отсканированный продукт"
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 16, weight: .bold)
        }
        enum Alert {
            static let title: String = "Проверка продукта"
            static let message: String = "Продукт не найден"
            static let okTitle: String = "ОК"
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
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        // Убираем полупрозрачность и ставим нужные цвета
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Constants.NavigationBar.textColor
        navigationItem.title = Constants.NavigationBar.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.NavigationBar.textColor,
            .font: Constants.NavigationBar.font
        ]
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        titleLabel.numberOfLines = Constants.TitleLabel.numberofLines
        titleLabel.backgroundColor = Constants.TitleLabel.backgroundColor
        titleLabel.font = Constants.TitleLabel.font
        titleLabel.textColor = Constants.TitleLabel.textColor
        titleLabel.textAlignment = Constants.TitleLabel.textAlignment
    }
    
    private func configureBrandLabel() {
        brandLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        brandLabel.numberOfLines = Constants.BrandLabel.numberLines
        brandLabel.backgroundColor = Constants.BrandLabel.backgroundcolor
        brandLabel.font = Constants.TitleLabel.font
        brandLabel.textAlignment = Constants.TitleLabel.textAlignment
    }
    
    private func configureAllergenStack() {
        allergensStack.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        allergensStack.backgroundColor = Constants.AllergenStack.backgroundColor
        allergensStack.layer.cornerRadius = Constants.AllergenStack.cornerRadius
        allergensStack.axis = Constants.AllergenStack.axis
        allergensStack.layoutMargins = Constants.AllergenStack.layoutMargins
        allergensStack.isLayoutMarginsRelativeArrangement = Constants.AllergenStack.isLayoutMarginsRelativeArrangement
        allergensStack.addArrangedSubview(allergensLabel)
        
        if allergens.isEmpty {
            let allergenView = AllergenView(frame: .zero, allergen: Constants.AllergenStack.emptyAllergen)
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
        allergensStack.pinTop(to: nameStack.bottomAnchor, Constants.AllergenStack.topConstraint)
        allergensStack.pinHorizontal(to: contentView, Constants.AllergenStack.horizontalConstraint)
    }
    
    private func configureTracesStack() {
        tracesStack.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        tracesStack.axis = Constants.TracesStack.axis
        tracesStack.backgroundColor = Constants.TracesStack.backgroundColor
        tracesStack.layer.cornerRadius = Constants.TracesStack.cornerRadius
        tracesStack.layoutMargins = Constants.TracesStack.layoutMargins
        tracesStack.isLayoutMarginsRelativeArrangement = Constants.TracesStack.isLayoutMarginsRelativeArrangement
        tracesStack.addArrangedSubview(tracesLabel)
        
        if traces.isEmpty {
            let traceView = TraceView(frame: .zero, trace: Constants.TracesStack.emptyTrace)
            tracesStack.addArrangedSubview(traceView)
        } else {
            for trace in traces {
                let traceView = TraceView(frame: .zero, trace: trace)
                tracesStack.addArrangedSubview(traceView)
            }
        }
        contentView.addSubview(tracesStack)
        tracesStack.pinCenterX(to: contentView)
        tracesStack.pinTop(to: allergensStack.bottomAnchor, Constants.TracesStack.topConstraint)
        tracesStack.pinHorizontal(to: contentView, Constants.TracesStack.horizontalConstraint)
        tracesStack.pinBottom(to: contentView)
    }
    
    private func configureNameStack() {
        nameStack.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        nameStack.axis = Constants.NameStack.axis
        nameStack.backgroundColor = Constants.NameStack.backgroundColor
        nameStack.layer.cornerRadius = Constants.NameStack.cornerRadius
        nameStack.addArrangedSubview(tracesLabel)
        nameStack.layoutMargins = Constants.NameStack.layoutMargins
        nameStack.isLayoutMarginsRelativeArrangement = Constants.NameStack.isLayoutMarginsRelativeArrangement
        
        for nameLabel in [brandLabel, titleLabel] {
            nameStack.addArrangedSubview(nameLabel)
        }
        contentView.addSubview(nameStack)
        nameStack.pinCenterX(to: contentView)
        nameStack.pinTop(to: contentView.topAnchor, Constants.NameStack.topConstraint)
        nameStack.pinHorizontal(to: contentView, Constants.NameStack.horizontalConstraint)
    }
    
    private func configureAllergensLabel() {
        allergensLabel.textColor = Constants.AllergenLabel.textColor
        allergensLabel.text = Constants.AllergenLabel.text
        allergensLabel.font = Constants.AllergenLabel.font
    }
    
    private func configureTracesLabel() {
        tracesLabel.textColor = Constants.TracesLabel.textColor
        tracesLabel.text = Constants.TracesLabel.text
        tracesLabel.font = Constants.TracesLabel.font
        tracesLabel.numberOfLines = Constants.TracesLabel.numberOfLines
    }
    
    
    //MARK: - Methods
    func showAlert(message: String) {
        let alert = UIAlertController(title: Constants.Alert.title, message: message, preferredStyle: .alert)
        if message == Constants.Alert.message {
            let okAction = UIAlertAction(title: Constants.Alert.okTitle, style: .default) {[weak self] _ in
                self?.interactor.goBackToScanner(request: ScannedProductModels.GoBackToScanner.Request(navigationController: self?.navigationController))
            }
            alert.addAction(okAction)
        } else {
            alert.addAction(UIAlertAction(title: Constants.Alert.okTitle, style: .default, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
}
