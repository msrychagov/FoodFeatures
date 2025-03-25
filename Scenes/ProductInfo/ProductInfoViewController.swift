import UIKit

final class ProductInfoViewController: UIViewController, ProductInfoViewLogic {
    //MARK: - Constants
    enum Constants {
        enum General {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
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
        
        AuthService().isLiked(productId: Int(product.id!)) { [weak self] result in
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
        wrap.setHeight(300)
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
        nameLabel.numberOfLines = 2
        nameLabel.font = .systemFont(ofSize: 25, weight: .bold)
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.pinTop(to: wrap.bottomAnchor, 2)
        nameLabel.pinHorizontal(to: contentView, 10) // Привязываем к contentView!
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
        // Создаём конфигурацию символа (например, 40pt)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        
        // Применяем конфигурацию к изображению
        let heartNormal = UIImage(systemName: "heart", withConfiguration: symbolConfig)
        let heartSelected = UIImage(systemName: "heart.fill", withConfiguration: symbolConfig)
        
        likeButton.setImage(heartNormal, for: .normal)
        likeButton.setImage(heartSelected, for: .selected)
        
        //        likeButton.imageView?.contentMode = .scaleAspectFit
        
        view.addSubview(likeButton)
        likeButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        likeButton.pinRight(to: view.trailingAnchor, 20)
        likeButton.addTarget(self, action: #selector (addToFavoriteTapped), for: .touchUpInside)
    }
    //MARK: - Actions
    @objc private func addToFavoriteTapped() {
        if !likeButton.isSelected {
            likeButton.tintColor = .red
            let productId = product.id
            
            // Вызываем наш сервис, который добавляет товар в избранное
            AuthService().addToFavorites(productId: productId!) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        NotificationCenter.default.post(name: Notification.Name("FavoriteAdded"), object: self.product)
                        // Успешно добавили
                        self.showAlert(title: "Успех", message: "Товар добавлен в избранное!")
                    case .failure(let error):
                        // Обработка ошибки
                        self.showAlert(title: "Ошибка", message: "Не удалось добавить в избранное: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            likeButton.tintColor = .black
            let productId = product.id
            
            AuthService().removeFromFavorites(productId: Int(productId!)) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        // Успешно добавили
                        NotificationCenter.default.post(name: Notification.Name("FavoriteRemoved"), object: self.product.id)
                        self.showAlert(title: "Успех", message: "Товар удален из избранного!")
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
