import UIKit

final class CategoriesViewController: UIViewController, CategoriesViewLogic {
    
    //MARK: - Constants
    enum Constants {
        enum CollectionView {
            static let sectionInset: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
            static let minimumInteritemSpacing: CGFloat = 16
            static let minimumLineSpacing: CGFloat = 16
            static let heightAndWidthDifference: CGFloat = 48
            static let backgroundColor: UIColor = .clear
            static let numberOfRows: CGFloat = 2
        }
    }
    
    //MARK: - Variables
    private let interactor: CategoriesBuisnessLogic
    private let market: Market
    private let chapter: String
    private var displayedCategories: [Category] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // Задаём отступы
        layout.sectionInset = Constants.CollectionView.sectionInset
        layout.minimumInteritemSpacing = Constants.CollectionView.minimumInteritemSpacing
        layout.minimumLineSpacing = Constants.CollectionView.minimumLineSpacing
        
        let itemWidth: CGFloat = (view.bounds.width - Constants.CollectionView.minimumInteritemSpacing - Constants.CollectionView.sectionInset.left - Constants.CollectionView.sectionInset.right) / Constants.CollectionView.numberOfRows  // 2 колонки
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Constants.CollectionView.heightAndWidthDifference)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = GeneralConstants.translatesAutoresizingMaskIntoConstraints
        cv.dataSource = self
        cv.delegate = self
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        return cv
    }()
    
    //MARK: Lyfecycles
    init (interactor: CategoriesBuisnessLogic, market: Market, chapter: String) {
        self.interactor = interactor
        self.market = market
        self.chapter = chapter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        interactor.setDisplayedCategories(request: CategoriesModels.SetDisplayedCategories.Request())
        configureUI()
    }
    
    //MARK: - Methods
    func displayCategories(viewModel: CategoriesModels.SetDisplayedCategories.ViewModel) {
        self.displayedCategories = viewModel.displayedCategories
        collectionView.reloadData()
    }
    
    //MARK: - Configure
    private func configureUI() {
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = market.title
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.pin(to: view)
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.reuseIdentifier,
            for: indexPath
        )
        guard let categoryCell = cell as? CategoryCell else {
            return cell
        }
        categoryCell.configure(category: displayedCategories[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = displayedCategories[indexPath.item]
        let request = CategoriesModels.RouteToProductsList.Request(navigationController: self.navigationController, marketId: self.market.id, category: selectedCategory, chapter: self.chapter)
        interactor.routeToProductsList(request: request)
    }
}
