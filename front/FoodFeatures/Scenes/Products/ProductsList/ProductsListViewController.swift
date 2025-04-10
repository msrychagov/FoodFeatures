//
//  LactoseFree.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 22.03.2025.
//

import UIKit

class ProductsListViewController: UIViewController, ProductsListViewLogic{
    //MARK: - Constants
    enum Constants {
        enum General {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum CollectionView {
            static let itemSize: CGSize = .init(width: 180, height: 250)
            static let minimumInteritemSpacing: CGFloat = 16
            static let minimumLineSpacing: CGFloat = 16
            static let alwaysBounceVertical: Bool = true
            static let showsVerticalScrollIndicator: Bool = false
            static let contentInset: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
            static let constraint: CGFloat = 5
            static let backgroundColor: UIColor = .clear
        }
        
        enum ChapterName {
            static let def: String = "Default"
        }
        
        enum NotificationNames {
            static let add: String = "FavoriteAdded"
            static let remove: String = "FavoriteRemoved"
        }
        enum Alert {
            static let alertTitle: String = "Ошибка"
            static let actionTitle: String = "OK"
        }
    }
    
    //MARK: - Variables
    var storeId: Int
    var category: Category
    var chapter: String
    let interactor: ProductsBuisnessLogic
    private let collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                    collectionViewLayout: UICollectionViewFlowLayout())
    // Массив товаров
    var displayedProducts: [Product] = []
    init(interactor: ProductsBuisnessLogic, marketId: Int, category: Category, chapter: String) {
        self.interactor = interactor
        self.storeId = marketId
        self.category = category
        self.chapter = chapter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        title = category.title
        
        if chapter == Constants.ChapterName.def {
            let request = ProductsModels.Load.Request(storeId: storeId, categoryId: category.id)
            interactor.loadProducts(request: request)
        }
        else {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleFavoriteAdded(notification:)),
                name: Notification.Name(Constants.NotificationNames.add),
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleFavoriteRemoved(notification:)),
                name: Notification.Name(Constants.NotificationNames.remove),
                object: nil
            )
            let request = ProductsModels.Load.Request(storeId: storeId, categoryId: category.id)
            interactor.loadFavoriteProducts(request: request)
        }
        // Начинаем загрузку
        configureUI()
    }
    
    @objc private func handleFavoriteRemoved(notification: Notification) {
        guard let removedProduct = notification.object as? Product else { return }
        let removedProductId = removedProduct.id
        // Находим индекс удалённого товара в массиве products
        if let index = displayedProducts.firstIndex(where: { $0.id == removedProductId }) {
            displayedProducts.remove(at: index)
            // Обновляем collectionView — можно использовать deleteItems(at:) для анимации или reloadData()
            collectionView.reloadData()
        }
    }
    
    @objc private func handleFavoriteAdded(notification: Notification) {
        guard let addedProduct = notification.object as? Product else { return }
        // Если такого товара ещё нет в списке, добавляем
        if !displayedProducts.contains(where: { $0.id == addedProduct.id }) && addedProduct.specificies == category.title {
            displayedProducts.append(addedProduct)
            // Можно вставить с анимацией, например:
            collectionView.reloadData()
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func displayProducts(viewModel: ProductsModels.Load.ViewModel) {
        // Сохраняем продукты, обновляем таблицу
        self.displayedProducts = viewModel.displayedProducts
        self.collectionView.reloadData()
    }
    
    func displayError(message: String) {
        // Показываем алерт или что-то ещё
        let alert = UIAlertController(title: Constants.Alert.alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Alert.actionTitle, style: .default))
        present(alert, animated: true)
    }
    
    
    private func configureUI() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = Constants.CollectionView.minimumInteritemSpacing
            flowLayout.minimumLineSpacing = Constants.CollectionView.minimumLineSpacing
            flowLayout.sectionInset = Constants.CollectionView.contentInset
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        collectionView.register(ProductsListCell.self, forCellWithReuseIdentifier: ProductsListCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = Constants.CollectionView.alwaysBounceVertical
        collectionView.showsVerticalScrollIndicator = Constants.CollectionView.showsVerticalScrollIndicator
        collectionView.backgroundColor = Constants.CollectionView.backgroundColor
        view.addSubview(collectionView)
        collectionView.pin(to: view, Constants.CollectionView.constraint)
    }
}

extension ProductsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsListCell.reuseIdentifier, for: indexPath
        )
        
        guard let productCell = cell as? ProductsListCell else {
            return cell
        }
        
        let product = displayedProducts[indexPath.item]
        productCell.configure(title: product.name, imageUrl: product.image_url)
        
        return cell
    }
}

extension ProductsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = displayedProducts[indexPath.item]
        interactor.routeToProductInfo(request: .init(navigationController: navigationController, product: product))
    }
}


extension ProductsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Количество ячеек в строке
        let numberOfItemsInRow: CGFloat = 2
        // Отступы по краям коллекции (inset), плюс межэлементный интервал
        let totalSpacing = (Constants.CollectionView.contentInset.left
                            + Constants.CollectionView.contentInset.right
                            + (Constants.CollectionView.minimumInteritemSpacing * (numberOfItemsInRow - 1)))
        // Вычисляем доступную ширину под ячейки
        let availableWidth = collectionView.bounds.width - totalSpacing
        // Делим доступную ширину на количество ячеек в строке
        let width = floor(availableWidth / numberOfItemsInRow)
        // Задаём высоту, либо исходя из пропорций, либо фиксированную
        let height: CGFloat = 250
        
        return CGSize(width: width, height: height)
    }
}
