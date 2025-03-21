import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создаём контроллеры для вкладок
        let productsVC = ProductsAssembly.build() // "Продукты"
        let profileVC = ProfileAssembly.build() // "Профиль"
        
        // Задаём каждому контроллеру UITabBarItem
        
        productsVC.tabBarItem = UITabBarItem(
            title: "Продукты",
            image: UIImage(systemName: "bag.fill"),
            selectedImage: UIImage(systemName: "bag.fill")
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.fill"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        // Оборачиваем каждый контроллер в UINavigationController, если нужно
        let productsNav = UINavigationController(rootViewController: productsVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        // Назначаем контроллеры таб-бара
        viewControllers = [productsNav, profileNav]
        
        // Настраиваем внешний вид таб-бара
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        // Для iOS 15+ используем UITabBarAppearance
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemRed
            
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
