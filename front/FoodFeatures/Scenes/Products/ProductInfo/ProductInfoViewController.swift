import UIKit

final class ProductInfoViewController: UIViewController, ProductInfoViewLogic {
    //MARK: - Constants
    enum Constants {
        enum General {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum Wrap {
            static let height: CGFloat = 300
            static let backgroundColor: UIColor = .white
        }
        enum ImageView {
            static let contentMode: UIView.ContentMode = .scaleAspectFit
        }
        enum NameLabel {
            static let numberOfLines: Int = 0
            static let lineBreakMode: NSLineBreakMode = .byWordWrapping
            static let font: UIFont = .systemFont(ofSize: 16, weight: .bold)
            static let textAlignment: NSTextAlignment = .center
            static let topConstraint: CGFloat = 2
            static let horizontalConstraint: CGFloat = 10
        }
        enum InfoViewTitles {
            static let generalCharacteristics: String = "Общие характеристики"
            static let description: String = "Описание"
            static let nutritionalValue: String = "Пищевая ценность на 100г"
        }
        enum InfoViewDescriptionFieldsTitles {
            static let generalCharacteristics: String = "Особенности"
            static let description: String = "Состав"
            enum nutritionValue {
                static let protein: String = "Белки"
                static let fat: String = "Жиры"
                static let carbs: String = "Углеводы"
                static let calories: String = "Энергетическая ценность"
            }
        }
        enum LikeButton {
            static let symbolCopnfig: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
            static let normalImageName: String = "heart"
            static let selectedImageName: String = "heart.fill"
            static let topConsraint: CGFloat = 20
            static let rightConsraint: CGFloat = 20
            static let selectedTintColor: UIColor = .red
            static let normalTintColor: UIColor = .black
        }
        
        enum Notification {
            static let addName: String = "FavoriteAdded"
            static let removeName: String = "FavoriteRemoved"
        }
        
        enum InfoViewStack {
            static let axis: NSLayoutConstraint.Axis = .vertical
            static let spacing: CGFloat = 8
            static let aligment: UIStackView.Alignment = .fill
            static let distribution: UIStackView.Distribution = .fill
            static let topConstraint: CGFloat = 24
        }
    }
    
    //MARK: - Variables
    private let interactor: ProductInfoBuisnessLogic
    private let scrollView: UIScrollView = UIScrollView()
    private let wrap: UIView = UIView()
    private let contentView: UIView = UIView()
    private let stackView: UIStackView = UIStackView()
    private let imageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let likeButton: UIButton = UIButton(type: .custom)
    private let infoViewsStack: UIStackView = UIStackView()
    private let generalCharacteristicsInfoView: ExpandableProductInfoView = ExpandableProductInfoView()
    private let descriptionInfoView: ExpandableProductInfoView = ExpandableProductInfoView()
    private let nutritionalValueInfoView: ExpandableProductInfoView = ExpandableProductInfoView()
    private let product: Product
    private var isLiked: Bool
    var isFavorite: Bool = false {
        didSet {
            likeButton.isSelected = isFavorite
            likeButton.tintColor = likeButton.isSelected ? .red : .black
        }
    }
    
    //MARK: Lyfecycles
    init (interactor: ProductInfoBuisnessLogic, product: Product) {
        self.interactor = interactor
        self.product = product
        self.isLiked = false
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.getImage(request: .init(product: product))
        interactor.isAuthed()
    }
    
    //MARK: - Methods
    func displayIsAuthed(viewModel: ProductInfoModels.IsAuthed.ViewModel) {
        if viewModel.isAuthed {
            interactor.isFavorite(request: .init(product: product))
        } else {
            DispatchQueue.main.async {
                self.isFavorite = false
            }
        }
    }
    
    func displayGotImage(viewModel: ProductInfoModels.SetImage.ViewModel) {
        DispatchQueue.main.async {
            self.imageView.image = viewModel.image
        }
    }
    
    func displayIsFavorite(viewModel: ProductInfoModels.IsFavorite.ViewModel) {
        DispatchQueue.main.async {
            self.isFavorite = viewModel.isFavorite
        }
    }
    
    func displayToggleFavoriteSuccess(viewModel: ProductInfoModels.ToggleFavorite.ViewModelSuccess) {
        // Обновляем локальное состояние
        DispatchQueue.main.async {
            self.isFavorite = viewModel.isFavoriteNow
//            self.likeButton.tintColor = self.isFavorite ? .red : .black
        }
    }
    
    func displayToggleFavoriteFailure(viewModel: ProductInfoModels.ToggleFavorite.AlertViewModel) {
        let alert = AlertFactory.make(from: viewModel) { [weak self] in
            self?.interactor.goAuth(request: .init(navigationController: self?.navigationController))
        }
        present(alert, animated: true)
    }
    
    //MARK: - Configure
    private func configureUI() {
        configureScrollView()
        configureContentView()
        configureWrap()
        configureImageView()
        configureLikeButton()
        configureNameLabel()
        configureGeneralCharacteristicsInfoView()
        configureDescriptionInfoView()
        configureNutritionalValueInfoView()
        configureInfoViewsStack()
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func configureWrap() {
        wrap.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        wrap.backgroundColor = Constants.Wrap.backgroundColor
        contentView.addSubview(wrap)
        wrap.pinTop(to: contentView.topAnchor)
        wrap.pinHorizontal(to: contentView)
        wrap.setHeight(Constants.Wrap.height)
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        imageView.contentMode = Constants.ImageView.contentMode
        wrap.addSubview(imageView)
        imageView.pin(to: wrap)
    }
    
    private func configureLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        
        // Применяем конфигурацию к изображению
        let heartNormal = UIImage(systemName: Constants.LikeButton.normalImageName, withConfiguration: Constants.LikeButton.symbolCopnfig)
        let heartSelected = UIImage(systemName: Constants.LikeButton.selectedImageName, withConfiguration: Constants.LikeButton.symbolCopnfig)
        
        likeButton.setImage(heartNormal, for: .normal)
        likeButton.setImage(heartSelected, for: .selected)
        wrap.addSubview(likeButton)
        likeButton.pinTop(to: wrap.topAnchor, Constants.LikeButton.topConsraint)
        likeButton.pinRight(to: wrap.trailingAnchor, Constants.LikeButton.rightConsraint)
        likeButton.addTarget(self, action: #selector (heartWasTapped), for: .touchUpInside)
    }
    
    private func configureNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        nameLabel.text = product.name
        nameLabel.numberOfLines = Constants.NameLabel.numberOfLines
        nameLabel.lineBreakMode = Constants.NameLabel.lineBreakMode
        nameLabel.font = Constants.NameLabel.font
        nameLabel.textAlignment = Constants.NameLabel.textAlignment
        contentView.addSubview(nameLabel)
        nameLabel.pinTop(to: wrap.bottomAnchor, Constants.NameLabel.topConstraint)
        nameLabel.pinHorizontal(to: contentView, Constants.NameLabel.horizontalConstraint) // Привязываем к contentView!
    }
    
    private func configureGeneralCharacteristicsInfoView() {
        generalCharacteristicsInfoView.configure(title: Constants.InfoViewTitles.generalCharacteristics,
                                                 descriptionfields: [DescriptionField(title: Constants.InfoViewDescriptionFieldsTitles.generalCharacteristics, value: product.specificies)])
    }
    
    private func configureDescriptionInfoView() {
        descriptionInfoView.configure(title: Constants.InfoViewTitles.description,
                                      descriptionfields: [DescriptionField(title: Constants.InfoViewDescriptionFieldsTitles.description, value: product.compound)]
        )
    }
    
    private func configureNutritionalValueInfoView() {
        nutritionalValueInfoView.configure(title: Constants.InfoViewTitles.nutritionalValue,
                                           descriptionfields: [DescriptionField(title: Constants.InfoViewDescriptionFieldsTitles.nutritionValue.protein, value: product.protein),
                                                               DescriptionField(title: Constants.InfoViewDescriptionFieldsTitles.nutritionValue.fat, value: product.fats),
                                                               DescriptionField(title: Constants.InfoViewDescriptionFieldsTitles.nutritionValue.carbs, value: product.carbs),
                                                               DescriptionField(title: Constants.InfoViewDescriptionFieldsTitles.nutritionValue.calories, value: product.energy_value)]
        )
    }
    
    
    
    private func configureInfoViewsStack () {
        infoViewsStack.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        infoViewsStack.axis = Constants.InfoViewStack.axis
        infoViewsStack.spacing = Constants.InfoViewStack.spacing
        infoViewsStack.alignment = Constants.InfoViewStack.aligment   // чтобы каждый сабвью растягивался по ширине
        infoViewsStack.distribution = Constants.InfoViewStack.distribution
        for infoView in [generalCharacteristicsInfoView, descriptionInfoView, nutritionalValueInfoView] {
            infoViewsStack.addArrangedSubview(infoView)
        }
        contentView.addSubview(infoViewsStack)
        infoViewsStack.pinTop(to: nameLabel.bottomAnchor, Constants.InfoViewStack.topConstraint)
        infoViewsStack.pinHorizontal(to: contentView)
        infoViewsStack.pinBottom(to: contentView)
    }

    //MARK: - Actions
    @objc private func heartWasTapped() {
        let request = ProductInfoModels.ToggleFavorite.Request(product: product, isCurrentlyFavorite: isFavorite)
        interactor.toggleFavorite(request: request)
        }
}
