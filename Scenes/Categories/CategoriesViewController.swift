import UIKit

final class CategoriesViewController: UIViewController, CategoriesViewLogic {
    
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    //MARK: - Variables
    private let interactor: CategoriesBuisnessLogic
    private let market: Market
    private let chapter: String
    private let categories: [Category] = [
        Category(title: "Без глютена", image: "glutenfree", id: 5),
        Category(title: "Без лактозы", image: "lactosefree", id: 2),
        Category(title: "Халяль", image: "halal", id: 4)
    ]
    
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
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = market.title
    }
    //MARK: - Actions
}

// MARK: - UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.reuseIdentifier,
            for: indexPath
        )
        guard let categoryCell = cell as? CategoryCell else {
            return cell
        }
        categoryCell.configure(category: categories[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate (если нужно обработать нажатия)
extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.item]
        let categoryProductsVC = ProductsListAssembly.build(marketId: self.market.id, categoryId: selectedCategory.id, chapter: chapter)
        
        navigationController?.pushViewController(categoryProductsVC, animated: true)
        print("Вы выбрали категорию: \(selectedCategory.title)")
        // Тут можно, например, открыть детальный экран или фильтровать список продуктов
    }
}
