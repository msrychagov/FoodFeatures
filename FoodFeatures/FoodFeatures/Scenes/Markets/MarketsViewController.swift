import UIKit

final class MarketsViewController: UIViewController, MarketsViewLogic {
    //MARK: - Constants
    enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum NavigationBar {
            static let title: String = "Магазины"
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 20, weight: .bold)
        }
        enum TableView {
            static let bottomConstraint: CGFloat = 10
            static let horizontalConstraint: CGFloat = 10
        }
    }
    
    //MARK: - Variables
    private let interactor: MarketsBuisnessLogic
    private let table: UITableView = UITableView()
    private let markets: [Market] = [
        Market(title: "Перекрёсток", image: "perekrestok", id: 1),
        Market(title: "Лента", image: "lenta", id: 2),
        Market(title: "Магнит", image: "magnit", id: 3)]
    
    //MARK: Lyfecycles
    init (interactor: MarketsBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
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
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        configureUI()
    }
    
    private func configureUI() {
        configureTableView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Constants.NavigationBar.textColor
        navigationItem.title = Constants.NavigationBar.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.NavigationBar.textColor,
            .font: Constants.NavigationBar.font
        ]
    }
        
    private func configureTableView() {
        table.register(MarketCell.self, forCellReuseIdentifier: MarketCell.reuseIdentifier)
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        view.addSubview(table)
        table.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        table.pinBottom(to: view.bottomAnchor, Constants.TableView.bottomConstraint)
        table.pinHorizontal(to: view, Constants.TableView.horizontalConstraint)
    }
    //MARK: - Actions
}

//MARK: - Extensions
extension MarketsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(
            withIdentifier: MarketCell.reuseIdentifier,
            for: indexPath
        )
        guard let marketCell = cell as? MarketCell else { return cell }
        marketCell.selectionStyle = .none
        let market = markets[indexPath.row]
        marketCell.configure(image: UIImage(named: market.image)!)
        return marketCell
    }
}

extension MarketsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMarket = markets[indexPath.item]
        
        interactor.routeToCategories(request: Markets.routeToCategories.Request(navigationController: self.navigationController, market: selectedMarket, chapter: "Default"))
        print("Вы выбрали категорию: \(selectedMarket.title)")
        // Тут можно, например, открыть детальный экран или фильтровать список продуктов
    }
}
