import UIKit

class FavoritesViewController: UIViewController, FavoritesViewLogic{
    
    //MARK: - Constants
    enum Constants {
        enum NavigationBar {
            static let title: String = "Избранное"
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 20, weight: .bold)
        }
    }
    private let interactor: FavoritesBuisnessLogic
    private let tableView = UITableView()
    private var favorites: [Product] = []
    private let markets: [Market] = [
        Market(title: "Перекрёсток", image: "perekrestokFavorite", id: 1),
        Market(title: "Лента", image: "lentaFavorite", id: 2),
        Market(title: "Магнит", image: "magnitFavorite", id: 3)]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // Задаём отступы
        layout.sectionInset = UIEdgeInsets(top: 16, left: 14, bottom: 14, right: 16)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        // Размер ячейки — подбирайте под свой дизайн
        let itemWidth: CGFloat = (view.bounds.width - 14*3) / 2  // 2 колонки
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(
            FavoriteMarketCell.self,
            forCellWithReuseIdentifier: FavoriteMarketCell.reuseIdentifier
        )
        return cv
    }()
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        fetchFavoriteProducts()
//    }
    
    init (interactor: FavoritesBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
            // Убираем полупрозрачность и ставим нужные цвета
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = GeneralConstants.viewControllerBackgroundColor
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "Избранное"
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
        configureNavigationBar()
        NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Constants.NavigationBar.textColor
        navigationItem.title = Constants.NavigationBar.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.NavigationBar.textColor,
            .font: Constants.NavigationBar.font
        ]
    }
    
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 180, height: 250)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 10
            layout.invalidateLayout()
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        collectionView.register(ProductsListCell.self, forCellWithReuseIdentifier: ProductsListCell.reuseIdentifier)
        collectionView.backgroundColor = .green
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.pin(to: view, 5)
    }
    
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return markets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMarketCell.reuseIdentifier, for: indexPath
        )
        
        guard let favoriteMarketCell = cell as? FavoriteMarketCell else {
            return cell
        }
        
        favoriteMarketCell.configure(market: markets[indexPath.item])
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let market = markets[indexPath.item]
        let categories = CategoriesAssembly.build(market: market, chapter: "Favorites")
        navigationController?.pushViewController(categories, animated: true)
    }
}
