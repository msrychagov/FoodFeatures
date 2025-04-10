//
//  AlertFactory.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 17.04.2025.
//

import UIKit
/// 2. Сама фабрика
enum AlertFactory {
    static func make(from viewModel: ProductInfoModels.ToggleFavorite.AlertViewModel,
                     authHandler: (() -> Void)? = nil) -> UIAlertController {
        
        let title: String
        let alert = UIAlertController(title: nil,
                                      message: viewModel.message,
                                      preferredStyle: .alert)
        
        switch viewModel.kind {
        case .auth:
            title = "Ошибка авторизации"
            alert.title = title
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Авторизация",
                                          style: .default) { _ in
                authHandler?()          // навигацию передаём колбэком
            })
            
        case .server:
            title = "Ошибка сервера"
            alert.title = title
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel))
            
        }
        return alert
    }
}
