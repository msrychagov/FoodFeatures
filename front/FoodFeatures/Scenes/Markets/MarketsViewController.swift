import UIKit

final class MarketsViewController: UIViewController, MarketsViewLogic {
    //MARK: - Constants
    enum Constants {
        static let chapter: String = "Default"
        enum NavigationBar {
            static let title: String = "Магазины"
            static let textColor: UIColor = .black
        }
        enum TableView {
            static let backgroundColor: UIColor = .clear
            static let separatorStyle: UITableViewCell.SeparatorStyle = .none
            static let contentInset: UIEdgeInsets = UIEdgeInsets(top: 8,
                                                                 left: 0,
                                                                 bottom: 16,
                                                                 right: 0)
            static let horizontalConstraint: CGFloat = 16
        }
    }
    
    //MARK: - Variables
    private let interactor: MarketsBuisnessLogic
    private let table: UITableView = UITableView()
    private var markets: [Market] = []
    
    //MARK: Lyfecycles
    init (interactor: MarketsBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if #available(iOS 11.0, *) {
        //            table.contentInsetAdjustmentBehavior = .never
        //        } else {
        //            automaticallyAdjustsScrollViewInsets = false
        //        }
        view.backgroundColor = GeneralConstants.viewControllerBackgroundColor
        interactor.fetchMarkets(request: .init())
        configureUI()
    }
    //MARK: - Methods
    func fetchMarkets(viewModel: Markets.FetchMarkets.ViewModel) {
        self.markets = viewModel.markets
        table.reloadData()
    }
    //MARK: - Configure
    private func configureUI() {
        configureTableView()
        configureNavigationBar()
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
    
    private func configureTableView() {
        table.register(MarketCell.self, forCellReuseIdentifier: MarketCell.reuseIdentifier)
        table.backgroundColor = Constants.TableView.backgroundColor
        table.separatorStyle = Constants.TableView.separatorStyle
        table.dataSource = self
        table.delegate = self
        table.contentInset = Constants.TableView.contentInset
        //        table.rowHeight = UITableView.automaticDimension
        view.addSubview(table)
        table.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        table.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        table.pinHorizontal(to: view, Constants.TableView.horizontalConstraint)
    }
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
        interactor.routeToCategories(request: Markets.RouteToCategories.Request(navigationController: self.navigationController, market: selectedMarket, chapter: Constants.chapter))
    }
}
