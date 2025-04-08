import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Назначаем контроллеры таб-бара
        if AuthManager.shared.isLoggedIn() {
            viewControllers = loggedUserTabBar()
        } else {
            viewControllers = unauthUserTabBar()
        }
        
        // Настраиваем внешний вид таб-бара
        setupTabBarAppearance()
    }
    
    func loggedUserTabBar() -> [UINavigationController] {
        let marketsVC = MarketsAssembly.build()
        let scannerVC = ScannerAssembly.build()
        let favoritesVC = FavoritesAssembly.build()
        let profileVC = ProfileAssembly.build()
        
        marketsVC.tabBarItem = UITabBarItem(
            title: "Магазины",
            image: UIImage(systemName: "basket.fill"),
            selectedImage: UIImage(systemName: "basket.fill")
        )
        
        scannerVC.tabBarItem = UITabBarItem(
            title: "Сканер",
            image: UIImage(systemName: "barcode"),
            selectedImage: UIImage(systemName: "barcode")
        )
        
        favoritesVC.tabBarItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(systemName: "heart.fill"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.fill"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        let scannerNav = UINavigationController(rootViewController: scannerVC)
        let marketsNav = UINavigationController(rootViewController: marketsVC)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        return [marketsNav, scannerNav, favoritesNav, profileNav]
    }
    
    func unauthUserTabBar() -> [UINavigationController] {
        let marketsVC = MarketsAssembly.build()
        let scannerVC = ScannerAssembly.build()
        let unAuthorizedProfileVC = UnAuthorizedUserAssembly.build()
        let unAuthorizedFavoritesVC = UnAuthorizedUserAssembly.build()
        
        marketsVC.tabBarItem = UITabBarItem(
            title: "Магазины",
            image: UIImage(systemName: "basket.fill"),
            selectedImage: UIImage(systemName: "basket.fill")
        )
        
        scannerVC.tabBarItem = UITabBarItem(
            title: "Сканер",
            image: UIImage(systemName: "barcode"),
            selectedImage: UIImage(systemName: "barcode")
        )
        
        unAuthorizedFavoritesVC.tabBarItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(systemName: "heart.fill"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        unAuthorizedProfileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.fill"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        let scannerNav = UINavigationController(rootViewController: scannerVC)
        let marketsNav = UINavigationController(rootViewController: marketsVC)
        let unAuthorizedFavoritesNav = UINavigationController(rootViewController: unAuthorizedFavoritesVC)
        let unAuthorizedProfileNav = UINavigationController(rootViewController: unAuthorizedProfileVC)
        
        return [marketsNav, scannerNav, unAuthorizedFavoritesNav, unAuthorizedProfileNav]
    }
    
    func switchToAuth() {
        viewControllers = loggedUserTabBar()
    }
    
    func switchToUnauth() {
        viewControllers = unauthUserTabBar()
    }
    
    private func setupTabBarAppearance() {
        // Для iOS 15+ используем UITabBarAppearance
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = GeneralConstants.buttonsBackgroundColor
            
            // Цвет иконок и текста в активном состоянии
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
            
            // Цвет иконок и текста в неактивном состоянии
            appearance.stackedLayoutAppearance.normal.iconColor = .white.withAlphaComponent(0.7)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white.withAlphaComponent(0.7)
            ]
            
            tabBar.standardAppearance = appearance
            
            // Если используете прокрутку (scrollEdge), назначьте и его
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        } else {
            // На iOS < 15
            tabBar.barTintColor = .systemRed
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        }
        
        // Если хотите уменьшить шрифт, используйте UITabBarItem.appearance() или конкретный атрибут
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    }
}
