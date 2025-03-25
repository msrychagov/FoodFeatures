import UIKit

final class ProductInfoViewController: UIViewController, ProductInfoViewLogic {
    //MARK: - Constants
    enum Constants {
        enum General {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum Wrap {
            static let height: CGFloat = 300
        }
        enum NameLabel {
            static let numberOfLines: Int = 2
            static let font: UIFont = .systemFont(ofSize: 25, weight: .bold)
            static let textAlignment: NSTextAlignment = .center
            static let topConstraint: CGFloat = 2
            static let horizontalConstraint: CGFloat = 10
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
        
        enum Description {
            static let numberOfLines: Int = 2
            static let font: UIFont = .systemFont(ofSize: 25, weight: .bold)
            static let textAlignment: NSTextAlignment = .center
            static let topConstraint: CGFloat = 2
            static let horizontalConstraint: CGFloat = 10
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
    private let product: Product
    private var isLiked: Bool
    var isFavorite: Bool = false {
        didSet {
            likeButton.isSelected = isFavorite
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FavoriteService().isLiked(productId: Int(product.id!)) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let isLikedFromServer):
                    self.isLiked = isLikedFromServer
                    // Теперь мы точно знаем, что сервер ответил
                    if isLikedFromServer {
                        self.likeButton.isSelected = true
                        self.likeButton.tintColor = .red
                    } else {
                        self.likeButton.isSelected = false
                        self.likeButton.tintColor = .black
                    }
                    
                case .failure(let error):
                    print("Ошибка загрузки с сервера: \(error)")
                    // Можно тут же поставить какое-то дефолтное состояние кнопки,
                    // если вам нужно
                    self.likeButton.isSelected = false
                    self.likeButton.tintColor = .black
                }
            }
        }
    }
    
    
    //MARK: - Methods
    override func viewDidLoad() {
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configureScrollView()
        configureContentView()
        configureWrap()
        configureImageView()
        configureNameLabel()
        //        configureDescriptionLabel()
        configureLikeButton()
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        view.addSubview(scrollView)
        scrollView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        scrollView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        scrollView.pinHorizontal(to: view)
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
        wrap.backgroundColor = .white
        contentView.addSubview(wrap)
        wrap.pinTop(to: contentView.topAnchor)
        wrap.pinHorizontal(to: contentView)
        wrap.setHeight(Constants.Wrap.height)
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        
        guard let url = URL(string: self.product.image_url) else {
            return
        }
        // Запускаем асинхронную загрузку
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Если ошибка или данных нет, просто выходим
            guard let data = data, error == nil else {
                return
            }
            // Создаём UIImage из полученных данных
            let downloadedImage = UIImage(data: data)
            
            // Обновление интерфейса всегда делаем на главном потоке
            DispatchQueue.main.async {
                self?.imageView.image = downloadedImage
            }
        }.resume()
        imageView.contentMode = .scaleAspectFit
        wrap.addSubview(imageView)
        imageView.pin(to: wrap)
    }
    
    private func configureNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        nameLabel.text = product.name
        nameLabel.numberOfLines = Constants.NameLabel.numberOfLines
        nameLabel.font = Constants.NameLabel.font
        nameLabel.textAlignment = Constants.NameLabel.textAlignment
        contentView.addSubview(nameLabel)
        nameLabel.pinTop(to: wrap.bottomAnchor, Constants.NameLabel.topConstraint)
        nameLabel.pinHorizontal(to: contentView, Constants.NameLabel.horizontalConstraint) // Привязываем к contentView!
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        descriptionLabel.text = product.description
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.numberOfLines = 10
        contentView.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: nameLabel.bottomAnchor, 2)
        descriptionLabel.pinHorizontal(to: contentView, 10) // Привязываем к contentView!
        // Не забудьте добавить нижнее ограничение, если это последний элемент:
        descriptionLabel.pinBottom(to: contentView.bottomAnchor, 2)
    }
    
    private func configureLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Применяем конфигурацию к изображению
        let heartNormal = UIImage(systemName: Constants.LikeButton.normalImageName, withConfiguration: Constants.LikeButton.symbolCopnfig)
        let heartSelected = UIImage(systemName: Constants.LikeButton.selectedImageName, withConfiguration: Constants.LikeButton.symbolCopnfig)
        
        likeButton.setImage(heartNormal, for: .normal)
        likeButton.setImage(heartSelected, for: .selected)
        
        view.addSubview(likeButton)
        likeButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.LikeButton.topConsraint)
        likeButton.pinRight(to: view.trailingAnchor, Constants.LikeButton.rightConsraint)
        likeButton.addTarget(self, action: #selector (addToFavoriteTapped), for: .touchUpInside)
    }
    
    func displayToggleFavoriteSuccess(viewModel: ProductInfoModels.ToggleFavorite.ViewModelSuccess) {
        // Обновляем локальное состояние
        DispatchQueue.main.async {
            self.isFavorite = viewModel.isFavoriteNow
            print("Успешно изменили избранное, текущее состояние: \(self.isFavorite)")
        }
    }
    
    func displayToggleFavoriteFailure(viewModel: ProductInfoModels.ToggleFavorite.ViewModelFailure) {
        // Показываем ошибку
        let alert = UIAlertController(title: "Ошибка", message: viewModel.errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    //MARK: - Actions
    @objc private func addToFavoriteTapped() {
//        let request = ProductInfoModels.ToggleFavorite.Request(
//            productId: product.id!,
//                    isCurrentlyFavorite: isFavorite
//                )
//        interactor.toggleFavorite(request: request)
        
                if !likeButton.isSelected {
                    likeButton.tintColor = Constants.LikeButton.selectedTintColor
                    let productId = product.id
        
                    // Вызываем наш сервис, который добавляет товар в избранное
                    FavoriteService().addToFavorites(productId: productId!) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                NotificationCenter.default.post(name: Notification.Name(Constants.Notification.addName), object: self.product)
                                // Успешно добавили
        //                        self.showAlert(title: "Успех", message: "Товар добавлен в избранное!")
                            case .failure(let error):
                                // Обработка ошибки
                                self.showAlert(title: "Ошибка", message: "Не удалось добавить в избранное: \(error.localizedDescription)")
                            }
                        }
                    }
                } else {
                    likeButton.tintColor = Constants.LikeButton.normalTintColor
                    let productId = product.id
        
                    FavoriteService().removeFromFavorites(productId: Int(productId!)) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                // Успешно добавили
                                NotificationCenter.default.post(name: Notification.Name(Constants.Notification.removeName), object: self.product.id)
                                // Отправляем уведомление, что товар удалён
                            case .failure(let error):
                                // Обработка ошибки
                                self.showAlert(title: "Ошибка", message: "Не удалось удалить товар из избранного: \(error.localizedDescription)")
                            }
                        }
                    }
                }
        likeButton.isSelected.toggle()
    }
    
    
    // MARK: - Helpers
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
}
