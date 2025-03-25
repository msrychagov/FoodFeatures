//
//  LactoseFree.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 22.03.2025.
//

import UIKit

class ProductsListViewController: UIViewController, ProductsListViewLogic {
    //MARK: - Constants
    enum Constants {
        enum General {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum CollectionView {
            static let itemSize: CGSize = .init(width: 180, height: 250)
            static let minimumInteritemSpacing: CGFloat = 4
            static let minimumLineSpacing: CGFloat = 10
            static let alwaysBounceVertical: Bool = true
            static let showsVerticalScrollIndicator: Bool = false
            static let contentInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
            static let constraint: CGFloat = 5
            static let backgroundColor: UIColor = .clear
        }
    }
    
    //MARK: - Variables
    var storeId: Int
    var categoryId: Int
    var chapter: String
    let interactor: ProductsBuisnessLogic
    private let collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                    collectionViewLayout: UICollectionViewFlowLayout())
    // Массив товаров
    var displayedProducts: [Product] = []
    init(interactor: ProductsBuisnessLogic, marketId: Int, categoryId: Int, chapter: String) {
        self.interactor = interactor
        self.storeId = marketId
        self.categoryId = categoryId
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
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleFavoriteAdded(notification:)),
                                                   name: Notification.Name("FavoriteAdded"),
                                                   object: nil)
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleFavoriteRemoved(notification:)),
                                                   name: Notification.Name("FavoriteRemoved"),
                                                   object: nil)
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        title = "Продукты"
        
        if chapter == "Default" {
            let request = ProductsModels.Load.Request(storeId: storeId, categoryId: categoryId)
            interactor.loadProducts(request: request)
//            LoadProductsService().fetchProducts(storeId: marketId, categoryId: categoryId) { [weak self]
//                result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let remoteProducts):
//                        self!.products = remoteProducts
//                        self?.collectionView.reloadData()
//                    case .failure(let error):
//                                    print("Ошибка загрузки с сервера: \(error)")
//                                }
//                }}
        }
        else {
            let request = ProductsModels.Load.Request(storeId: storeId, categoryId: categoryId)
            interactor.loadFavoriteProducts(request: request)
//            LoadProductsService().fetchFavoriteProducts(storeId: marketId, categoryId: categoryId) { [weak self]
//                result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let remoteProducts):
//                        self!.products = remoteProducts
//                        self?.collectionView.reloadData()
//                    case .failure(let error):
//                                    print("Ошибка загрузки с сервера: \(error)")
//                                }
//                }}
        }
        // Начинаем загрузку
        configureUI()
    }
    
    @objc private func handleFavoriteRemoved(notification: Notification) {
        guard let removedProductId = notification.object as? Int else { return }
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
        if !displayedProducts.contains(where: { $0.id == addedProduct.id }) {
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
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
    
    private func configureUI() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = Constants.CollectionView.itemSize
            layout.minimumInteritemSpacing = Constants.CollectionView.minimumInteritemSpacing
            layout.minimumLineSpacing = Constants.CollectionView.minimumLineSpacing
            layout.invalidateLayout()
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = Constants.General.translatesAutoresizingMaskIntoConstraints
        collectionView.register(ProductsListCell.self, forCellWithReuseIdentifier: ProductsListCell.reuseIdentifier)
        collectionView.backgroundColor = .green
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = Constants.CollectionView.alwaysBounceVertical
        collectionView.showsVerticalScrollIndicator = Constants.CollectionView.showsVerticalScrollIndicator
        collectionView.contentInset = Constants.CollectionView.contentInset
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
        print("Выбран продукт: \(product.name)\nId: \(product.id)")
        let detailViewController = ProductInfoAssembly.build(product: product)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
