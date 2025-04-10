import UIKit

class FavoritesViewController: UIViewController, FavoritesViewLogic{
    
    //MARK: - Constants
    enum Constants {
        static let chapter: String = "Favorites"
        enum NavigationBar {
            static let title: String = "Избранное"
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 1, weight: .bold)
        }
        enum CollectionView {
            static let sectionInset: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
            static let minimumInteritemSpacing: CGFloat = 16
            static let minimumLineSpacing: CGFloat = 16
            static let heightAndWidthDifference: CGFloat = 48
            static let backgroundColor: UIColor = .clear
            static let numberOfRows: CGFloat = 2
        }
        
    }
    private let interactor: FavoritesBuisnessLogic
    private var markets: [Market] = []
    private let tableView = UITableView()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // Задаём отступы
        layout.sectionInset = Constants.CollectionView.sectionInset
        layout.minimumInteritemSpacing = Constants.CollectionView.minimumInteritemSpacing
        layout.minimumLineSpacing = Constants.CollectionView.minimumLineSpacing
        
        let itemWidth: CGFloat = (view.bounds.width - Constants.CollectionView.minimumInteritemSpacing - Constants.CollectionView.sectionInset.left - Constants.CollectionView.sectionInset.right) / Constants.CollectionView.numberOfRows
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Constants.CollectionView.heightAndWidthDifference)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        cv.dataSource = self
        cv.delegate = self
        cv.register(FavoriteMarketCell.self, forCellWithReuseIdentifier: FavoriteMarketCell.reuseIdentifier)
        return cv
    }()
    
    //MARK: - Lyfecycle
    init (interactor: FavoritesBuisnessLogic) {
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
        interactor.setMarkets(request: Favorites.Markets.Request())
        configureUI()
    }
    
    //MARK: - Methods
    func displayMarkets(viewModel: Favorites.Markets.ViewModel) {
        markets = viewModel.markets
        collectionView.reloadData()
    }
    
    //MARK: - Configure
    private func configureUI() {
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        let standardAppearance = UINavigationBarAppearance()
        // Убираем полупрозрачность и ставим нужные цвета
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        standardAppearance.shadowColor = .black
        standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithOpaqueBackground()
        scrollEdgeAppearance.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        scrollEdgeAppearance.shadowColor = .clear
        scrollEdgeAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        
        navigationController?.navigationBar.tintColor = Constants.NavigationBar.textColor
        navigationItem.title = Constants.NavigationBar.title
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.pin(to: view)
    }
    
}


//MARK: - CollectionViewDataSource
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

//MARK: - CollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let request = Favorites.RouteToCategories.Request(navigationController: navigationController, market: self.markets[indexPath.item], chapter: Constants.chapter)
        interactor.routeToCategories(request: request)
    }
}
